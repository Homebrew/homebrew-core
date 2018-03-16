class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20170611.tar.gz"
  sha256 "dcdc7a9b7c9fd7144c90baa5f48041af434ed4c8f77c8e41f1017789a2f9c017"
  revision 1

  bottle :unneeded

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
