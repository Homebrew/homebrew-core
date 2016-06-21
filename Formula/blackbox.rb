class Blackbox < Formula
  desc "Safely store secrets in Git/Mercurial/Subversion"
  homepage "https://github.com/StackExchange/blackbox"
  url "https://github.com/StackExchange/blackbox/archive/v1.20160122.tar.gz"
  sha256 "ac5de1d74fdbe88604b34949f3949e53cb72e55e148e46b8c2be98806c888a10"
  revision 1

  bottle :unneeded

  depends_on :gpg => :run

  def install
    # Prefer GPG2 by default.
    inreplace "bin/_blackbox_common.sh", ":=gpg", ":=gpg2"

    libexec.install Dir["bin/*"]
    bin.write_exec_script Dir[libexec/"*"].select { |f| File.executable? f }
  end

  test do
    # Note that test do is always in temporary path, with HOME captured,
    # so this doesn't interfere with a user's pre-existing keychain.
    (testpath/"batchgpg").write <<-EOS.undent
    Key-Type: RSA
    Key-Length: 2048
    Subkey-Type: RSA
    Subkey-Length: 2048
    Name-Real: Testing
    Name-Email: testing@foo.bar
    Expire-Date: 1d
    Passphrase: brew
    %commit
    EOS
    system "gpg2", "--batch", "--gen-key", "batchgpg"

    system "git", "init"
    system bin/"blackbox_initialize", "yes"
    add_created_key = shell_output("#{bin}/blackbox_addadmin Testing 2>&1")
    assert_match "<testing@foo.bar>", add_created_key
  end
end
