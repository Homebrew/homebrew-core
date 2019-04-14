class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/releases/download/v2.3.0/ilmbase-2.3.0.tar.gz"
  sha256 "456978d1a978a5f823c7c675f3f36b0ae14dba36638aeaa3c4b0e784f12a3862"

  bottle do
    cellar :any
    sha256 "63e5e1e6f1e17b8aa264b14cb1e8120a7e606b4f6173c85c945ea35ab911f8bc" => :mojave
    sha256 "5621509767a95332eff8e26f7fe80c6bce9c3c271fa8521e234263b3c3d67454" => :high_sierra
    sha256 "7b40da5907be805067a7af87b5a5af2dac9e446478de06316a059fa9c4f9a9c0" => :sierra
    sha256 "402fe7453b9ca2c4c4a3fbdb9557156819e26c959e18c096dcceab8b1b6ce9a5" => :el_capitan
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
