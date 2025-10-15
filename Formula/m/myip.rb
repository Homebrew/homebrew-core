class Myip < Formula
  desc "Simple CLI tool to print the current IP address and hostname"
  homepage "https://github.com/Checkm8ra1n/myip"
  url "https://github.com/Checkm8ra1n/myip/archive/refs/heads/main.tar.gz"
  version "latest"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Installa lo script Python puro con il nome corretto
    bin.install "myip.py" => "myip"
    # Rende eseguibile
    chmod 0755, bin/"myip"
  end

  test do
    system "#{bin}/myip"
  end
end
