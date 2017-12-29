class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/password-store/password-store_1.7.1.orig.tar.xz"
  sha256 "f6d2199593398aaefeaa55e21daddfb7f1073e9e096af6d887126141e99d9869"
  revision 1
  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "8a66e0a2f89e7d36cd58dcb925a22c8c41cb549f4bb01e3adda394c45ae9ef5a" => :high_sierra
    sha256 "cde7a0225dbcd62b9cc9d8e5e8d9ed8e0534bbe590cb3cc974cc31a8177defdd" => :sierra
    sha256 "692b37f152b5bad4d841323c7938b8d1f94c858026d7ad941b7a270ee9503705" => :el_capitan
    sha256 "692b37f152b5bad4d841323c7938b8d1f94c858026d7ad941b7a270ee9503705" => :yosemite
  end

  depends_on "qrencode"
  depends_on "tree"
  depends_on "gnu-getopt"
  depends_on "gnupg"

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}", "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    elisp.install "contrib/emacs/password-store.el"
    pkgshare.install "contrib"
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system bin/"pass", "init", "Testing"
      system bin/"pass", "generate", "Email/testing@foo.bar", "15"
      assert_predicate testpath/".password-store/Email/testing@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
