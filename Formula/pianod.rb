class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-301.tar.gz"
  sha256 "d6fa01d786af65fe3b4e6f4f97fa048db6619b9443e23f655d3ea8ab4766caee"

  bottle do
    sha256 "6c0dee18b03c7dfd0c4d752164b7e86edd84098f3dfccd4e248d4e2085314988" => :catalina
    sha256 "f5f17916dd35eb4ec45b7ad25ed7b82cd7f8b7dd4cd53846b4fd023e331cd622" => :mojave
    sha256 "0d3430afe66553f3b3a87798766ff1bccc2972ed2867a363ebf6d1b8a3ae57b1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++11"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
