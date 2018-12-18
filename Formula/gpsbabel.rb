class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/gpsbabel/gpsbabel/archive/gpsbabel_1_5_4.tar.gz"
  sha256 "8cd740db0b92610abff71e942e8a987df58cd6ca5f25cca86e15f2b00e190704"
  revision 2

  bottle do
    sha256 "afa69a0f0729d4ba82d1f36edee585ed6dc88be4d36d4bd93d0c8512ee13ff11" => :mojave
    sha256 "4c3f17308d3d81e9a3ca96fd278e30a0cf927642a82cdb76a46ca649a6d9bb6f" => :high_sierra
    sha256 "be91d28547a74b5a5e5564ee9b6bc5fe2c54dc2a62afd992ca00a4e0836e5dfb" => :sierra
  end

  depends_on "libusb"
  depends_on "qt"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
