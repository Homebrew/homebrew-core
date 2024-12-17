class Envvault < Formula
    desc "Secure, scalable, and collaborative environment variable management"
    homepage "https://envvault.com"
    url "https://envvault.com/releases/envvault-1.0.0.tar.gz"
    sha256 "cf92906d3c786eca81a4d6386b95a101aadd109eaee3a87889942900570af0ed"  # Use the real SHA256 here
    license "MIT"
  
    def install
      bin.install "envvault"
    end
  
    test do
      assert_match "envvault", shell_output("#{bin}/envvault --version", 2)
    end
  end

