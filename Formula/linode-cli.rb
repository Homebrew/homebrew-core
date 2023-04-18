class LinodeCli < Formula
  include Language::Python::Virtualenv

  desc "CLI for the Linode API"
  homepage "https://www.linode.com/products/cli/"
  url "https://files.pythonhosted.org/packages/b5/23/d307b8cde73d2378eb35f668c04b86728e9ab2b36c8129a1744613859cda/linode-cli-5.35.0.tar.gz"
  sha256 "4c135c0b47ae8cc141ab71f3117156cdb8001146e6e9885f6143954e5e0e0752"
  license "BSD-3-Clause"
  head "https://github.com/linode/linode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4492e5cb69be9c680fffd0cf5089d986f4f4888edaba593044f20dc7a0970b83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88383290e256f7055c4f49051344c99b89d384453856ea3278e304fd397ba515"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57e5c5c5a2cd8061caceda9592c9aa24eed38be4541f523e2a32b2cd37d8a8d7"
    sha256 cellar: :any_skip_relocation, ventura:        "2c78ca84a2c6c2f950fc452f8858926984a4cea2567cd60659b603011cbc7e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "999fa82d46299c3cebd3431d79081a9042254316340c630868bd3ecb08151f71"
    sha256 cellar: :any_skip_relocation, big_sur:        "35182e5e408270365074f2f554e299d9da58124bf559b34eee2cf033e74ec521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d736b20ba8e3475e429461e58c6e18ca8714cfdb1689f4ae2d9ca33e6f2d978"
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
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
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
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  # Fix the missing requirements.txt issue in pypi source tarball
  # https://github.com/linode/linode-cli/pull/435
  resource "requirements" do
    url "https://raw.githubusercontent.com/linode/linode-cli/v5.35.0/requirements.txt"
    sha256 "03139d1844f142725fc9cf14080039c5c0ecee84e0d8e43b36eb824e2d13a8d0"
  end

  def install
    buildpath.install resource("requirements")

    venv = virtualenv_create(libexec, "python3.11", system_site_packages: false)
    non_pip_resources = %w[terminaltables linode-api-spec requirements]
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
