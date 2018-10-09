class Objfw < Formula
  desc "Portable, lightweight framework for the Objective-C language"
  homepage "https://heap.zone/objfw/"
  url "https://heap.zone/objfw/downloads/objfw-0.90.2.tar.gz"
  sha256 "4de24703d45638093a5196eba278a05b3643e8be0ae2eece5c81ba3e2c20bdbb"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/objfw-new", "app", "Test"
    system "#{bin}/objfw-compile", "-o", "t", "Test.m"
    system "./t"
  end
end
