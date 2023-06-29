class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.io/"
  url "https://github.com/cask/cask/archive/v0.9.0.tar.gz"
  sha256 "5db17efe3a91d36f457e70f097cba5ed5de505971894bf2ec839c38d8c2dd120"
  license "GPL-3.0-or-later"
  head "https://github.com/cask/cask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "124bb75dc1cca68ba3d71a02b3e0661527a346828ac713b2536cf9505ccc985a"
  end

  depends_on "coreutils"
  depends_on "emacs"

  def install
    bin.install "bin/cask"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    prefix.install "package-build"
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
