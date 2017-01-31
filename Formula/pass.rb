class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.6.5.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/password-store/password-store_1.6.5.orig.tar.xz"
  sha256 "337a39767e6a8e69b2bcc549f27ff3915efacea57e5334c6068fcb72331d7315"
  revision 1

  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :sierra
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :el_capitan
    sha256 "c297d2352590d65c7edffe5667a11c4c89d2efa17a4b207e303883cf19c36770" => :yosemite
  end

  depends_on "pwgen"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on :gpg => :run

  def install
    system "make", "PREFIX=#{prefix}", "install"

    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
    zsh_completion.install "src/completion/pass.zsh-completion" => "_pass"
    bash_completion.install "src/completion/pass.bash-completion" => "password-store"
    fish_completion.install "src/completion/pass.fish-completion" => "pass.fish"
  end

  test do
    Gpg.create_test_key(testpath)
    system bin/"pass", "init", "Testing"
    system bin/"pass", "generate", "Email/testing@foo.bar", "15"
    assert File.exist?(".password-store/Email/testing@foo.bar.gpg")
  end
end
