class Nasty < Formula
  desc "Passphrase cracker for PGP or GPG keys"
  homepage "https://www.vanheusden.com/nasty/"
  url "https://www.vanheusden.com/nasty/nasty-0.6.tgz"
  sha256 "7607256d4672f1c52f2603d7b9691e7250bfe3a9b4f219fcbb61227172a7f6b7"
  depends_on "gpgme"

  def install
    system "make"
    bin.install "nasty"
  end

  test do
    (testpath/"gpg.conf").write <<~EOS
      pinentry-mode loopback
    EOS
    (testpath/"generate-key.script").write <<~EOS
      Key-Type: 1
      Key-Length: 2048
      Subkey-Type: 1
      Subkey-Length: 2048
      Name-Real: Joan of Arc
      Name-Email: joan@arc.com
      Passphrase: ya3Iey2H
      Expire-Date: 0
    EOS
    system "gpg", "--batch", "--homedir", testpath, "--no-permission-warning", "--gen-key", "generate-key.script"
    (testpath/"wordlist.txt").write <<~EOS
      badguess1
      badguess2
      ya3Iey2H
      badguess3
    EOS
    ENV["GNUPGHOME"] = testpath
    system "#{bin}/nasty", "-m", "file", "-i", testpath/"wordlist.txt", "-f", testpath/"passphrase.out"
    recovered = File.read(testpath/"passphrase.out")
    raise "Passphrase was not recovered" unless recovered =~ /ya3Iey2H/
  end
end
