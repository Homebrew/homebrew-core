class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.4.tar.xz"
  sha256 "cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0"
  license "GPL-2.0-or-later"
  head "https://git.zx2c4.com/password-store.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "05fce35468aa6e21cc355dcc0712d14e697e46714a3118a832c223bb8cee3365"
    sha256 cellar: :any_skip_relocation, big_sur:       "57fb3a87752b1c26bd0bba8710787a1b522f0feeb445d02241aefce9df4f2965"
    sha256 cellar: :any_skip_relocation, catalina:      "8130755986b8124ead30b7444bbab1f5b12b5481ddf914a310e221fdda736eb3"
    sha256 cellar: :any_skip_relocation, mojave:        "8130755986b8124ead30b7444bbab1f5b12b5481ddf914a310e221fdda736eb3"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8130755986b8124ead30b7444bbab1f5b12b5481ddf914a310e221fdda736eb3"
  end

  depends_on "gnu-getopt"
  depends_on "gnupg"
  depends_on "qrencode"
  depends_on "tree"

  def install
    system "make", "PREFIX=#{prefix}", "WITH_ALLCOMP=yes", "BASHCOMPDIR=#{bash_completion}",
                   "ZSHCOMPDIR=#{zsh_completion}", "FISHCOMPDIR=#{fish_completion}", "install"
    inreplace "#{bin}/pass",
              /^SYSTEM_EXTENSION_DIR=.*$/,
              "SYSTEM_EXTENSION_DIR=\"#{HOMEBREW_PREFIX}/lib/password-store/extensions\""
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
