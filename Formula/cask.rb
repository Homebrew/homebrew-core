class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.io/"
  url "https://github.com/cask/cask/archive/v0.8.8.tar.gz"
  sha256 "94f99d4161dedda3024312dc6b929be6319aff593a6d31f1cf4f2845ae6ca5c6"
  license "GPL-3.0-or-later"
  head "https://github.com/cask/cask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd85befe31659e948617b988ed604d70199af9e7dd22dcfc8be6d76ecd92ee0b"
  end

  depends_on "coreutils"
  depends_on "emacs"

  def install
    bin.install "bin/cask"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    elisp.install_symlink prefix/"cask.el"
    elisp.install_symlink prefix/"cask-bootstrap.el"

    # Stop cask performing self-upgrades.
    touch prefix/".no-upgrade"
  end

  test do
    (testpath/"Cask").write <<~EOS
      (source gnu)
      (depends-on "chess")
    EOS
    system bin/"cask", "install"
    (testpath/".cask").directory?
  end
end
