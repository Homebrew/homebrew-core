class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org" temporary? 503
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/5e/06/b6ffff222a6917e2f50705b553db35ef51b14857b147c12eb952c18c7148/breezy-3.3.1.tar.gz"
  sha256 "f00c2d17766f2947f6dc692e1247e5c1771a9186f4e941aa97ecc9d2ac23a8a6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec3a01b3f3b918cf378408857b9d0f7af17537376b08ee0cce4e3a8227eff97c"
    sha256 cellar: :any,                 arm64_monterey: "e0546eaad06c8b8637d96ef8229d8a1a1071eb65072df24b2e536d3ac83b405d"
    sha256 cellar: :any,                 arm64_big_sur:  "76e1a928b579aac251b6d5442a70535e1c08de14fa08e0c10440d69a922d6d05"
    sha256 cellar: :any,                 ventura:        "ffe1fdeadba5d4859cfdb5443b7ff03f38662f3729b80e43b2471ebe496184de"
    sha256 cellar: :any,                 monterey:       "0f5169dbe93a51c251d622af47e229a195d10ce0049f164f72579cc5c62ad7ad"
    sha256 cellar: :any,                 big_sur:        "29eee450b62c2f96454041236c7c70a8a12c1c06a424bb882eabbf4c18e1481c"
    sha256 cellar: :any,                 catalina:       "008d045767508012da55077c79152cb6bf8d5e14bd636428bb0b4d46eb18901a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cfb8a8b54972dcd4ddec9e0547e84a71360c3572e0e8fc114ab7a7c5bf4dfcc"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/d1/20/4c2ea55d6547460a93dce9112599953be1c939155eae7a8e11a17c4d0b2c/dulwich-0.20.50.tar.gz"
    sha256 "50a941796b2c675be39be728d540c16b5b7ce77eb9e1b3f855650ece6832d2be"
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
    url "https://files.pythonhosted.org/packages/96/d7/88848319e68f92db32982d0a2ca9b84c6fc05f38786f74c41c84adf26f6d/patiencediff-0.2.8.tar.gz"
    sha256 "d8838ade52d91e09e3689f63c9d3ac7cb3b039f6ce2d730a39a1641cb40cdd53"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
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
