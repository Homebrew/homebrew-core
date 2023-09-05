class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/v1.8.1.tar.gz"
  sha256 "fd6fb2c8e785c0e66e0aef9184d14bb3e1e83fd42dfd2e97823f3e1a740bc19a"
  license "MIT"
  head "https://github.com/dracula/emacs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "27ee077214351648848dd86db492cc00023c4dfc1c50d03e0ed431ce2fd319a9"
  end

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}/emacs/site-lisp/emacs-dracula/dracula-theme.el"
  end
end
