class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https://www.mkdocs.org/"
  url "https://files.pythonhosted.org/packages/ed/bb/24a22f8154cf79b07b45da070633613837d6e59c7d870076f693b7b1c556/mkdocs-1.5.3.tar.gz"
  sha256 "eb7c99214dcb945313ba30426c2451b735992c73c2e10838f76d09e39ff4d0e2"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d265b9eb4167e6c3f7e3924666c94840ecaa824cc614d4b99d1312f5f19c70de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f195c032f34e3cf521d9747e16f5d7eada8f820c88774713f92a900d1a86051f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41cdc1ebb990b2b918b15b24ba59a9ac474fd83bbc9d62d204c34fd6bcfdffa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "6882b163de5b2bb03e84cfc0ea6393cc37e9eec993555b8210edc52590339b5b"
    sha256 cellar: :any_skip_relocation, ventura:        "f1e012b3d2f71fd3a5ec080efa67221b93511bc9771430b597f6d3a06ad0c2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "2f70c24c75fc4d120012bd2da14731ba02e587adcd969709688915c7e52aed4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de47d980cbf275d945d58d5d9bfd254f8664b30e53892feed97e16e43d778ad9"
  end

  depends_on "python-click"
  depends_on "python-markdown"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/d9/29/d40217cbe2f6b1359e00c6c307bb3fc876ba74068cbab3dde77f03ca0dc4/ghp-import-2.1.0.tar.gz"
    sha256 "9c535c4c61193c2df8871222567d7fd7e5014d835f97dc7b7439069e2413d343"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml-env-tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/95/a6/d6ef450393dac5734c63c40a131f66808d2e6f59f6165ab38c98fbe4e6ec/watchdog-3.0.0.tar.gz"
    sha256 "4d98a320595da7a7c5a18fc48cb633c2e73cda78f93cac2ef42d42bf609a33f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
