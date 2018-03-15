class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/ilmbase-2.2.0.tar.gz"
  mirror "https://mirrorservice.org/sites/download.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    cellar :any
    rebuild 3
    sha256 "f53b502c8a59462466c610d127cdc2be288b472c4fbe76fa6affbff9498dac44" => :high_sierra
    sha256 "6fee028cc8dc306fc1c48b9015c48c02049f3c281e496af1448ca65d13c8405c" => :sierra
    sha256 "a18e2d6ecd45ff0ea78f856374aa11386b5fd2c2e82a335271b62c917f33caf4" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install %w[Half HalfTest Iex IexMath IexTest IlmThread Imath ImathTest]
  end

  test do
    cd pkgshare/"IexTest" do
      system ENV.cxx, "-I#{include}/OpenEXR", "-I./", "-c",
             "testBaseExc.cpp", "-o", testpath/"test"
    end
  end
end
