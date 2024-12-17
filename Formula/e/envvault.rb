class Envvault < Formula
    desc "Secure, scalable, and collaborative environment variable management. Built for developers, by developers"
    homepage "https://envvault.com/"
    url "https://envvault.com/releases/envvault-1.0.0.tar.gz"
    sha256 "cf92906d3c786eca81a4d6386b95a101aadd109eaee3a87889942900570af0ed"
    license "MIT"
  
    def install
      bin.install "envvault"
    end
  
    test do
      system "#{bin}/envvault", "--version"
    end
  end