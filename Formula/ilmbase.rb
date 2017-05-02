class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "http://www.openexr.com/"
  url "https://savannah.nongnu.org/download/openexr/ilmbase-2.2.0.tar.gz"
  mirror "https://mirrorservice.org/sites/download.savannah.gnu.org/releases/openexr/ilmbase-2.2.0.tar.gz"
  sha256 "ecf815b60695555c1fbc73679e84c7c9902f4e8faa6e8000d2f905b8b86cedc7"

  bottle do
    rebuild 2
    sha256 "486b1207a66286e6a1bd4aebeef5a249c0cae6daf4c28265b4c4dfef422dce65" => :sierra
    sha256 "4153f054e5c819ce35ccf70c6142b5d7059e84c9c0b446a9c83d8f590d7434c7" => :el_capitan
    sha256 "2bfd8bef08f89e6c84d6f9da5f5b3db38b787d33a3c6e6bb9751a9c43bbea2de" => :yosemite
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
