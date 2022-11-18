class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.4.tar.xz"
  sha256 "cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0"
  license "GPL-2.0-or-later"
  head "https://git.zx2c4.com/password-store.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ee1c46e172270c3161ef1d843c37f0bc21fb874af0b55dcd16ad32e795d17e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ee1c46e172270c3161ef1d843c37f0bc21fb874af0b55dcd16ad32e795d17e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbf5e1b314720d846525cc81a51f30e7cf7319a943f2fb395fb62202eff2c95c"
    sha256 cellar: :any_skip_relocation, ventura:        "d667e58dae216055777c9780d522b68c6868d7b23f9f712c09c29b1daf215b35"
    sha256 cellar: :any_skip_relocation, monterey:       "d667e58dae216055777c9780d522b68c6868d7b23f9f712c09c29b1daf215b35"
    sha256 cellar: :any_skip_relocation, big_sur:        "80812f17b470ea37c9027851ed71a6a09a8d0be359e6770c9e836646c68ade9e"
    sha256 cellar: :any_skip_relocation, catalina:       "80812f17b470ea37c9027851ed71a6a09a8d0be359e6770c9e836646c68ade9e"
    sha256 cellar: :any_skip_relocation, mojave:         "80812f17b470ea37c9027851ed71a6a09a8d0be359e6770c9e836646c68ade9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59753aa6bb5027b238e43bcdf87f603c9850166b485b85b6e457ecc8f4aff25c"
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
