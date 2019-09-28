class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/releases/download/v2.3.0/ilmbase-2.3.0.tar.gz"
  sha256 "456978d1a978a5f823c7c675f3f36b0ae14dba36638aeaa3c4b0e784f12a3862"

  bottle do
    cellar :any
    sha256 "d08e79f3a1e2875adba8c7affb929ac6fcdff93a66646a7f8c094263152912e4" => :catalina
    sha256 "436dbe30d0bc520c5c056dac23a3558dd2595e5f5b68c6c17e18566716c71e56" => :mojave
    sha256 "4ef6417909dee0313b9d493b5689d04382907beb650abc669fc5a6346e4c4d5b" => :high_sierra
    sha256 "f81d4a8993861dbde4c91b0783b03a943c710c060b938095511f3cf26beee589" => :sierra
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
