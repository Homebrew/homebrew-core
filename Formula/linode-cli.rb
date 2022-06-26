class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://github.com/linode/linode-cli/archive/refs/tags/5.20.0.tar.gz"
  sha256 "f8c6cca3249fa0146a6dbf8e48e95b8347c070629ca63b8f08b00b4acd0bd7b3"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a38b13a3229aeb6931f6ae14be5b3d1d5650a423a9fb1e895f50d5aa1e20ba1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae306a494c410a00f38ba8b2c822aba53042db05bad4868caa530a6017d3a74b"
    sha256 cellar: :any_skip_relocation, monterey:       "7f18f6245f674d43c37fec28b82a5c2a76e88b2253536fcea73d092a9839389c"
    sha256 cellar: :any_skip_relocation, big_sur:        "adb9f316134e6f194ac2eaf0597700b788e004811ddd4de198fcaf12b78839ee"
    sha256 cellar: :any_skip_relocation, catalina:       "54de4df3948703276ad5dfa1e2f4493e4c9f5c9d5ab133b2c637d35243cfd928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93b6873c92f1007a5fad182c88600a5b8247561505128e600116ff8e2fd3f4e"
  end

  depends_on "poetry" => :build # for terminaltables
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "linode-api-spec" do
    url "https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.114.0/openapi.yaml"
    sha256 "3991c45c292cb0ea6fc5cdbae019a503a646dd8d8d11c0b2192e90c547131ce0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/07/10/75277f313d13a2b74fc56e29239d5c840c2bf09f17bf25c02b35558812c6/certifi-2022.5.18.1.tar.gz"
    sha256 "9c5705e395cd70084351dd8ad5c41e65655e08ce46f2ec9cf6c2c08390f71eb7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    venv = virtualenv_create(libexec, "python3", system_site_packages: false)
    non_pip_resources = %w[terminaltables linode-api-spec]
    venv.pip_install resources.reject { |r| non_pip_resources.include? r.name }

    resource("terminaltables").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install Dir["dist/terminaltables-*.whl"].first
    end

    resource("linode-api-spec").stage do
      buildpath.install "openapi.yaml"
    end

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system "#{libexec}/bin/python3", "-m", "linodecli", "bake", "./openapi.yaml", "--skip-config"
    # Distribute the pickled spec object with the module
    cp "data-3", "linodecli"

    inreplace "setup.py" do |s|
      s.gsub! "version=get_version(),", "version='#{version}',"
      # Prevent setup.py from installing the bash_completion script
      s.gsub! "data_files=get_baked_files(),", ""
    end

    bash_completion.install "linode-cli.sh" => "linode-cli"

    venv.pip_install_and_link buildpath
  end

  test do
    require "securerandom"
    random_token = SecureRandom.hex(32)
    with_env(
      LINODE_CLI_TOKEN: random_token,
    ) do
      json_text = shell_output("linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end
