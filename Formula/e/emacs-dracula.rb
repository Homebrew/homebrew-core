class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https://github.com/dracula/emacs"
  url "https://github.com/dracula/emacs/archive/v1.8.2.tar.gz"
  sha256 "986d7e2a096a5bc528ca51d72f1ec22070c14fe877833d4eebad679170822a31"
  license "MIT"
  head "https://github.com/dracula/emacs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12f38f30a3f1104f1ddff8a14528542903fda394603c88be82feb8c9b1081a82"
  end

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}/emacs/site-lisp/emacs-dracula/dracula-theme.el"
  end
end
