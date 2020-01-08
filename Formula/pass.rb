class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.3.tar.xz"
  sha256 "2b6c65846ebace9a15a118503dcd31b6440949a30d3b5291dfb5b1615b99a3f4"
  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3f17d80446ffe12a32f8d90bde16550f88e0fe99c43e3fa0cf141a89bba30730" => :catalina
    sha256 "1a70cc714c9d37c24898d7da1431b5e5af1926abd41915cb546d6979ded1a4cb" => :mojave
    sha256 "c08575225a6e5aeace358c9c65666e08743814fd66017238e32b8fc3dff812aa" => :high_sierra
    sha256 "c08575225a6e5aeace358c9c65666e08743814fd66017238e32b8fc3dff812aa" => :sierra
  end

  depends_on "gnu-getopt"
  depends_on "gnupg"
  depends_on "qrencode"
  depends_on "tree"

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}", "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace "#{bin}/pass", /^SYSTEM_EXTENSION_DIR=.*$/, "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/password-store/extensions\""
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
