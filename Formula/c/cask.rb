class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.io/"
  url "https://github.com/cask/cask/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "755e71b7291678787afd497e34724004459add3e438d367e83891080f6d545a3"
  license "GPL-3.0-or-later"
  head "https://github.com/cask/cask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "57e45b5a8f5624932427a20879ead2c11b3d007b2b2bfbf751995219c4b1e7fe"
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
