class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/7b/a2/a6b11a38dbb6f32c8cbd77e95b00c8d16f1dbdaf3da105c5b2da18ac5fd7/linode-cli-5.33.0.tar.gz"
  sha256 "3682cc2f36df19e71accc6fbe12e5115e1d263c7c67fd1cc949eb518c114f7aa"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7f5beb88b9f890433a3b0b664eb901ba3e192e8ca2e6718daf5bf45af4699aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb3a9ab108ad347962ba7b971447be12c9758cb54bd614592a4b5e0bfbf6400"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b890477df7f3002ea585f3ccb96010c89cf549028a5d9fb5d1fc91b236d4079"
    sha256 cellar: :any_skip_relocation, ventura:        "8e93e6fefc6c40d6e206db8f2584bf1a831f4bdfcdd60bbc7611325aa072e800"
    sha256 cellar: :any_skip_relocation, monterey:       "b1c68547b483f9749d775359add682e8dd1e68585738cd97d4fa3370295d041d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a09670462acd198a717714b2636e6b7469a385353b58d92aab380bc8f64e28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c11b17141d981270d346953bd0293d6975faf7c8b97256386c0c6f07b11128"
  end

  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "linode-api-spec" do
    url "https://raw.githubusercontent.com/linode/linode-api-docs/refs/tags/v4.145.0/openapi.yaml"
    sha256 "c4075487eab4a92c73f1a2e747628440555a1c00aff44c7bc1217fde83385e36"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "terminaltables" do
    url "https://files.pythonhosted.org/packages/f5/fc/0b73d782f5ab7feba8d007573a3773c58255f223c5940a7b7085f02153c3/terminaltables-3.1.10.tar.gz"
    sha256 "ba6eca5cb5ba02bba4c9f4f985af80c54ec3dccf94cfcd190154386255e47543"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
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
      s.gsub! "version=version,", "version='#{version}',"
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
