class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://github.com/linode/linode-cli/archive/refs/tags/5.27.1.tar.gz"
  sha256 "d8da4dbc838b1f4a06b5a3ff2a2ae0dc59355139e990e7f4e65871583d55e5ea"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e56f3b98f1dc0b2debcaac19726b62d1ab4e130ad19e67934b0134701d2a121e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e640ac6ec849097d9f4c821865ccb59c1061cb5091d50e0fbd741180f651d8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d09fabdec2bcf873941b04858ad578085b7088de13d3029b2ab3ff6ae54efa"
    sha256 cellar: :any_skip_relocation, ventura:        "581dee10e18ec6a728d65981797eabf9e2a5a10b68b2933bacdea05f999ac8bd"
    sha256 cellar: :any_skip_relocation, monterey:       "85f38a2c310bda1ea243d5057c047bc9fe5454051ab2b2a3405c279ec0fcadcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cf3ef4d94d1752efc251a15fcc8e3c77c8e5da7e2427ced745da43500317cb7"
    sha256 cellar: :any_skip_relocation, catalina:       "f4a2f1ac725a0a82f44fc11319ac48a4c072cbadad70d1f8cb7019ae8d92304c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd53d20513a6c3e2912584c9639a4132be5503f17471ce18f9555ed5baa45f4"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.114.0/openapi.yaml"
    sha256 "3991c45c292cb0ea6fc5cdbae019a503a646dd8d8d11c0b2192e90c547131ce0"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11", system_site_packages: false)
    non_pip_resources = %w[terminaltables linode-api-spec]
    venv.pip_install resources.reject { |r| non_pip_resources.include? r.name }

    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove on next release: https://github.com/matthewdeanmartin/terminaltables/commit/9e3dda0efb54fee6934c744a13a7336d24c6e9e9
    resource("terminaltables").stage do
      inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
      inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'
      venv.pip_install_and_link Pathname.pwd
    end

    resource("linode-api-spec").stage do
      buildpath.install "openapi.yaml"
    end

    # The bake command creates a pickled version of the linode-cli OpenAPI spec
    system libexec/"bin/python3", "-m", "linodecli", "bake", "./openapi.yaml", "--skip-config"
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
      json_text = shell_output("#{bin}/linode-cli regions view --json us-east")
      region = JSON.parse(json_text)[0]
      assert_equal region["id"], "us-east"
      assert_equal region["country"], "us"
    end
  end
end
