class Qrq < Formula
  desc "High speed morse telegraphy trainer"
  homepage "https://fkurz.net/ham/qrq.html"
  url "https://fkurz.net/ham/qrq/qrq-0.3.5.tar.gz"
  sha256 "3b068c960d06b254dca5a48c7813f1653fc53cb6f5ced641e007091a7ec08d4f"
  license "GPL-2.0-or-later"

  def install
    system "make", "DESTDIR=#{prefix}", "USE_CA=YES", "USE_PA=NO", "OSX_PLATFORM=YES", "OSX_BUNDLE=NO"
    system "make", "install", "DESTDIR=#{prefix}", "USE_CA=YES", "USE_PA=NO", "OSX_PLATFORM=YES", "OSX_BUNDLE=NO"
  end
  test do
    system bin/"qrq", "--version"
  end
end
