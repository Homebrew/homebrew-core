class Librcsc < Formula
  desc "RoboCup Soccer Simulator library"
  homepage "https://osdn.net/projects/rctools/"
  # Canonical: https://osdn.net/dl/rctools/librcsc-4.1.0.tar.gz
  url "https://dotsrc.dl.osdn.net/osdn/rctools/51941/librcsc-4.1.0.tar.gz"
  sha256 "1e8f66927b03fb921c5a2a8c763fb7297a4349c81d1411c450b180178b46f481"

  livecheck do
    url "https://osdn.net/projects/rctools/releases/"
    regex(%r{value=.*?/rel/rctools/librcsc/v?(\d+(?:\.\d+)+)["']}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "843e8fa7ea1ce56071294f4a7b833ba4367ae3bb6363af83aeaae7f6d52d7636"
    sha256 cellar: :any,                 arm64_monterey: "6ed80637e973c59168c069fabeec0634448c8c161120c886f62cc3a498a5784e"
    sha256 cellar: :any,                 arm64_big_sur:  "833fe11162a367e783177275011d5156933cb33c29c34d423237a253214f5552"
    sha256 cellar: :any,                 ventura:        "6ac4c039117d05a0abdbcdfc09ac868667491fb670690929fc2597ffeeedf6fc"
    sha256 cellar: :any,                 monterey:       "5997731a4b6f409b301ea5014d41e53611048a5c8b8e59c78a31fba4f74626c0"
    sha256 cellar: :any,                 big_sur:        "e1af394e5832c69c864b55aece45a9a3a29664f32d28a20fb18f3e809eb01a31"
    sha256 cellar: :any,                 catalina:       "621b412c1c5c6623fef7b37e179dc75b47169b4a1007384aa2985daee09d6176"
    sha256 cellar: :any,                 mojave:         "0eeb0dfb16662da2760d8c753dc23049afdd9a8da0a5ae3eba9c5ac56ed00a41"
    sha256 cellar: :any,                 high_sierra:    "4bd96acb6e78620e25b3b33e745e7770ea812cde22a3d756ac978c778d3b993c"
    sha256 cellar: :any,                 sierra:         "c8b9dc2887f771f07b33bb70cec9ab62b4cee067f8b3a2d7ae57296428881031"
    sha256 cellar: :any,                 el_capitan:     "c2093c232c857c15bea5dd6c1c6df14aa4b00ed0c6eb3ab7e4d0d3f8c72b54c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6084c66b0de10b5c51e6094bfbf800fc8f7982354c3e64eb27122ae741b8fa9f"
  end

  depends_on "boost"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <rcsc/rcg.h>
      int main() {
        rcsc::rcg::PlayerT p;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lrcsc_rcg"
    system "./test"
  end
end
