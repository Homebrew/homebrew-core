class Cn < Formula
  desc "CLI for CommonNumerics routines (CRC-8/16/32/64, Base16/32/64)"
  homepage "https://github.com/JayBrown/cn"
  url "https://github.com/JayBrown/cn/archive/1.00.tar.gz"
  version "1.0.0"
  sha256 "4a11ccf8ba82f344f4d8faffc9a3cc28c5971d00f8e0f85d2682bb70e351e660"

  def install
    system "make prefix=#{prefix}"
    system "make clean"
    system "make cn"
    bin.install "cn"
    man1.install "cn.1"
  end

  test do
    system "#{bin}/cn", "version"
  end
end
