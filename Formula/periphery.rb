class Periphery < Formula
  desc "Tool to identify unused code in Swift projects"
  homepage "https://github.com/peripheryapp/periphery"
  url "https://github.com/peripheryapp/periphery/archive/1.4.0.tar.gz"
  sha256 "a47920cde9584547d46c8b1b9207ba06577ecb2cb25b21dceaeb5cad8d55a82d"

  bottle do
  end

  depends_on :xcode => "10.1"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/periphery"
  end
end
