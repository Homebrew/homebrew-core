class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv.html"
  url "https://download.drobilla.net/lilv-0.24.12.tar.bz2"
  sha256 "26a37790890c9c1f838203b47f5b2320334fe92c02a4d26ebbe2669dbd769061"
  license "ISC"
  revision 1

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?lilv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d7e2c05b21a8314da8f49bb4a66feb07c65883603885c6e9e8bda9a5d8748c75"
    sha256 cellar: :any,                 arm64_big_sur:  "069d1a84c3cdeaa7aa1f9e92e1afeb6161ba1070454885f0932a84e4ff85e8fd"
    sha256 cellar: :any,                 monterey:       "7bf3c51de78814ec48c4a856b9865f3848024a93bb2e7034be263c246a1db8d9"
    sha256 cellar: :any,                 big_sur:        "9e416b6f64740ae1bf0a9ba32edb3908eec389245e239a40c463a3e0aa399aa3"
    sha256 cellar: :any,                 catalina:       "044e3c4c9bf50262d84ca1036498f57e73f27dcdd445c0afae4685ea37a80b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e55820d75d9d5c70dcb4ed4632b904916258c9b59bb1312016b5aa2ae396df7"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <lilv/lilv.h>

      int main(void) {
        LilvWorld* const world = lilv_world_new();
        lilv_world_free(world);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/lilv-0", "-L#{lib}", "-llilv-0", "-o", "test"
    system "./test"

    system Formula["python@3.10"].opt_bin/"python3", "-c", "import lilv"
  end
end
