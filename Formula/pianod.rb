class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/Devel/pianod2-301.tar.gz"
  sha256 "d6fa01d786af65fe3b4e6f4f97fa048db6619b9443e23f655d3ea8ab4766caee"
  revision 1

  bottle do
    sha256 "891923360d9e05cc168e08373c41855f4700d84f9549ce6d86de2f7176a96992" => :catalina
    sha256 "8d1b17ccc15dc42000b73a5f054791f3ec98c48b47df731f5343e35199406ea9" => :mojave
    sha256 "37348131ed49c0cb261bb85f41b710fc791ca6aa423534063c3acb23596bfa27" => :high_sierra
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
