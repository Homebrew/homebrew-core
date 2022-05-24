class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v2.0.0.tar.gz"
  sha256 "0a8fee39dc46436472528ea3a5743c42ebefc068519545fe6fca57041f42deae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6910c4f3a0b2b04288b9ca0eedc866e6b83d14ac5276d4eb46651a0bb0c14333"
  end

  depends_on "gnupg"

  def install
    libexec.install Dir["bin/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
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
      system "git", "init"
      system bin/"blackbox_initialize", "yes"
      add_created_key = shell_output("#{bin}/blackbox_addadmin Testing 2>&1")
      assert_match "<testing@foo.bar>", add_created_key
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
