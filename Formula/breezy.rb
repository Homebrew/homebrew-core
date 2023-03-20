class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/ad/0e/4a937454a5a9e4d2ba7fcb37aeb64c082cddd3fd2761e445a5e11fcfd382/breezy-3.3.2.tar.gz"
  sha256 "4ea6949fcbb076b978545b099fac68abad35d6fa1899deef4f6b82a3dba257c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "230e71c407e4fec67229957ead35048f038192d0f34034fa1b2c7b366b486ad4"
    sha256 cellar: :any,                 arm64_monterey: "1701a27a93849535e27ce4812b5fac62d018a2073eaf3a5e2ebfdf090ed49240"
    sha256 cellar: :any,                 arm64_big_sur:  "22f05db8be7601e058b2254e104fa59573a4b6336df85410a4146f810d417d81"
    sha256 cellar: :any,                 ventura:        "4754073301e729bc055d682d3308f401507ccb6768c4e7f410f351dddc8b0f30"
    sha256 cellar: :any,                 monterey:       "4a8a3a8fa0b745669c7895a332e4e30541faf7e488cba066940bbf81799904fa"
    sha256 cellar: :any,                 big_sur:        "6e1991c4886348d9de5f963d46ec61104c839723fa36167dbf8df7e109ac961f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63c0e98e6474db8498d9b6296a23fa4d2fc2fce5c2bd96c16228310a441ccc4"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/14/a5/cf61f9209d48abf47d48086e0a0388f1030bb5f7cf2661972eee56ccee3d/dulwich-0.21.2.tar.gz"
    sha256 "d865ae7fd9497d64ce345a6784ff1775b01317fba9632ef9d2dfd7978f1b0d4f"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/cd/e1/94ff8d7ce12ca1fa76b7299af27819829cc8feea125615e6e1f805e8f4e6/fastbencode-0.1.tar.gz"
    sha256 "c1a978e75a5048bba833d90d6e748a55950ca8b59f12e917c2a2c8e7ca7eb6f5"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/7d/1d/1a2a0ff25b18cc3b7af41180821099696c2c34e4459fff09a2d19729281e/merge3-0.0.12.tar.gz"
    sha256 "fd3fc873dcf60b9944606d125f72643055c739ff41793979ccbdea3ea6818d36"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/87/05/52ccc6d1c3dbfdcfc93e7048b755389c3e3ee86bdeab2c09290cf905542c/patiencediff-0.2.12.tar.gz"
    sha256 "7ded9b7f2d5037081a9df63daa16629ce5c23b505f72737a2f332666a76c4232"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
