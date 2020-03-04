class Libmpdclient < Formula
  desc "Library for MPD in the C, C++, and Objective-C languages"
  homepage "https://www.musicpd.org/libs/libmpdclient/"
  url "https://www.musicpd.org/download/libmpdclient/2/libmpdclient-2.18.tar.xz"
  sha256 "4cb01e1f567e0169aca94875fb6e1200e7f5ce35b63a4df768ec1591fb1081fa"
  head "https://github.com/MusicPlayerDaemon/libmpdclient.git"

  bottle do
    cellar :any
    sha256 "50582687cdd7253ed54f1546560de8af52fd5a2a9a498ff54f61f78d3d93ef94" => :catalina
    sha256 "00448724103d2e46f09f820ab73acf60fefab37262828b0448bb02b374c2f4db" => :mojave
    sha256 "c946033764c18e8d8eb89a349e89b304024acfefac569455690a23c6e487a5f4" => :high_sierra
  end

  depends_on "doxygen" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mpd/client.h>
      int main() {
        mpd_connection_new(NULL, 0, 30000);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lmpdclient", "-o", "test"
    system "./test"
  end
end
