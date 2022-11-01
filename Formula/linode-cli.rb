class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://github.com/linode/linode-cli/archive/refs/tags/5.25.0.tar.gz"
  sha256 "a5c6593c3ceceda0bfb372ba751f73e07635d38a2d566fbabf5f8404419f4f6c"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "574dedca64a45e68713b03281adfbf0298274d9660073a452998c8ee05110bc6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e254146863a5535c65f1b19dd67f9e7916d836c4c74df58933345acede31fbd6"
    sha256 cellar: :any_skip_relocation, monterey:       "0d83019180d47092329fbd02161343be2e75cdd165dbf86fcf49b35c9951bd63"
    sha256 cellar: :any_skip_relocation, big_sur:        "53c2bde3b4988b2bf96e43ebc4a281a128cba9006060031a4cb6c3bd9d12817c"
    sha256 cellar: :any_skip_relocation, catalina:       "9815bd608fe696a40c63a87d1dbb4136d36832bb57d7ea66dfa4819d79034fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7358b24ebfb6d1d198cf7a64d32ec4e0f9e88f1702e87e8ea576d4498063f657"
  end

  depends_on "poetry" => :build # for terminaltables
  depends_on "openssl@1.1"
  depends_on "python@3.10"
  depends_on "pyyaml"

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
    venv = virtualenv_create(libexec, "python3.10", system_site_packages: false)
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
