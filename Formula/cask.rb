class Cask < Formula
  desc "Emacs dependency management"
  homepage "https://cask.readthedocs.io/"
  url "https://github.com/cask/cask/archive/v0.8.6.tar.gz"
  sha256 "0534a52f23c7b65e84aa4e1be62d623075cad39a19de38688fc0b5437cfb900f"
  license "GPL-3.0-or-later"
  head "https://github.com/cask/cask.git"

  bottle :unneeded

  depends_on "emacs"

  def install
    bin.install "bin/cask"
    prefix.install "templates"
    # Lisp files must stay here: https://github.com/cask/cask/issues/305
    prefix.install Dir["*.el"]
    elisp.install_symlink "#{prefix}/cask.el"
    elisp.install_symlink "#{prefix}/cask-bootstrap.el"

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
