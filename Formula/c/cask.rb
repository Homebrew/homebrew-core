class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.io/"
  url "https://github.com/cask/cask/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "5db17efe3a91d36f457e70f097cba5ed5de505971894bf2ec839c38d8c2dd120"
  license "GPL-3.0-or-later"
  head "https://github.com/cask/cask.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ca4c6e166929ce3044439e96d9730b41f205e1f751216443094da00def0c8959"
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
    (testpath/"Cask").write <<~LISP
      (source gnu)
      (depends-on "chess")
    LISP
    system bin/"cask", "install"
    (testpath/".cask").directory?
  end
end
