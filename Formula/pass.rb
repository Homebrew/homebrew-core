class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.tar.xz"
  sha256 "161ac3bd3c452a97f134aa7aa4668fe3f2401c839fd23c10e16b8c0ae4e15500"

  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :sierra
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :el_capitan
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :yosemite
  end

  depends_on "qrencode"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on :gpg => :run

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}", "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
  end

  test do
    Gpg.create_test_key(testpath)
    system bin/"pass", "init", "Testing"
    system bin/"pass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
