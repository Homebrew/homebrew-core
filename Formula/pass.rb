class Pass < Formula
  desc "Password manager"
  homepage "https://www.passwordstore.org/"
  url "https://git.zx2c4.com/password-store/snapshot/password-store-1.7.2.tar.xz"
  sha256 "4768c5e1965c4d2aeb28818681e484fb105b6f46cbd75a97608615c4ec6980ea"
  head "https://git.zx2c4.com/password-store", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "cf0b79bd037b53d985c758b9b1e90c530e6ce4fd976e9ad14595806610f4f248" => :high_sierra
    sha256 "cf0b79bd037b53d985c758b9b1e90c530e6ce4fd976e9ad14595806610f4f248" => :sierra
    sha256 "cf0b79bd037b53d985c758b9b1e90c530e6ce4fd976e9ad14595806610f4f248" => :el_capitan
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
