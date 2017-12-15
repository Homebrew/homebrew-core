class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_4.tar.gz"
  sha256 "8cd740db0b92610abff71e942e8a987df58cd6ca5f25cca86e15f2b00e190704"
  revision 1

  bottle do
    sha256 "661fe5794fa01cf8ee57511fc7dcd0a188cea17ef4ff307fadcc86f45fc074fe" => :high_sierra
    sha256 "573d8ca5e3785f8f5b02b148c63fcaa59d59b30ee4617a7e1cc6ae89df348973" => :sierra
    sha256 "61011f8373be4e2810679c3c608e39f73fc7b47033ada9ae0b6f33513f185827" => :el_capitan
    sha256 "b9dc431b4db6bd91e1a839e4650eafdb9dcf71f238b6d7fda606aa1c36303f10" => :yosemite
  end

  depends_on "qt"
  depends_on "libusb" => :optional

  # Fix build with Xcode 9, remove for next version
  patch do
    url "https://github.com/gpsbabel/gpsbabel/commit/b7365b93.patch?full_index=1"
    sha256 "e949182def36fef99889e43ba4bc4d61e36d6b95badc74188a8cd3da5156d341"
  end

  # Upstream fix to build with Qt 5.10, remove for next version
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ca4c4730/gpsbabel/qt5.10.patch"
    sha256 "09efe405f43ae26570d6b5fcb7c5bcc7e0c8bc9a9ad6700d3901bcdcc43c33cf"
  end

  def install
    ENV.cxx11
    args = ["--disable-debug", "--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--without-libusb" if build.without? "libusb"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.loc").write <<~EOS
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert_predicate testpath/"test.gpx", :exist?
  end
end
