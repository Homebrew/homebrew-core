class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/v1.7.0.tar.gz"
  sha256 "dbbcc968cf8187a8ada9f040137ba03dc0e51b285e96e128d26cea05cf470330"
  head "https://github.com/dracula/emacs.git"

  bottle :unneeded

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}/emacs/site-lisp/emacs-dracula/dracula-theme.el"
  end
end
