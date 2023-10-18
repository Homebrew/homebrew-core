class Libical < Formula
  desc "Implementation of iCalendar protocols and data formats"
  homepage "https://libical.github.io/libical/"
  url "https://github.com/libical/libical/releases/download/v3.0.17/libical-3.0.17.tar.gz"
  sha256 "bcda9a6db6870240328752854d1ea475af9bbc6356e6771018200e475e5f781b"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b23f302c22d873556a40b020fb3b0939bc44dd0f6541dbc3b462647616a42a6b"
    sha256 cellar: :any,                 arm64_ventura:  "98c223bbb2e4586797ccec2ab742059f89d3968479f09b3624215ff3151d7032"
    sha256 cellar: :any,                 arm64_monterey: "004f84dbd7affab5014b6d8d060876eab70036087b61b9a02ec82bd0fe167637"
    sha256 cellar: :any,                 sonoma:         "8446937e63e3b2a51c68ba61f0d306078a10ab357e9fb522fd1c00e2549aac95"
    sha256 cellar: :any,                 ventura:        "0d02d1d346013769b9ba7e35c9262d55df46953e1d3710deb4bf10a6498cd7f2"
    sha256 cellar: :any,                 monterey:       "bf3a57a6b2df4ef5bce998cdec73580a88208dc2fac41c30986360284b9e9dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cb997a45067e6538e449234866c645370994667957ee4934b1fffdc6ba8c144"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "cmake", ".", "-DBDB_LIBRARY=BDB_LIBRARY-NOTFOUND",
                         "-DENABLE_GTK_DOC=OFF",
                         "-DSHARED_ONLY=ON",
                         "-DCMAKE_INSTALL_RPATH=#{rpath}",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define LIBICAL_GLIB_UNSTABLE_API 1
      #include <libical-glib/libical-glib.h>
      int main(int argc, char *argv[]) {
        ICalParser *parser = i_cal_parser_new();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lical-glib",
                   "-I#{Formula["glib"].opt_include}/glib-2.0",
                   "-I#{Formula["glib"].opt_lib}/glib-2.0/include"
    system "./test"
  end
end
