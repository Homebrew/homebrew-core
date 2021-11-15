class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.9.tar.gz"
  sha256 "49ae9c52b5af81b405455c19fe24089d701761da2c45d22164a99576ceedfbed"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0c25377b7059c38ad35ba5cff9764113e46ff101341854cf0003d4886cf40063"
    sha256 cellar: :any,                 arm64_big_sur:  "3d5c0d07bfb27f55e4cd938e5e12ced37b0fa8b0776460bfa8748e8d113ca0af"
    sha256 cellar: :any,                 monterey:       "5a3f63e8e02536ba3ba0e2c1347fc69806cc9ab87029451f97be99d5251ecf54"
    sha256 cellar: :any,                 big_sur:        "0690d94faad89f7c1bacf2729dbcc0f965475080cc94be1bebcfa352d605507f"
    sha256 cellar: :any,                 catalina:       "7b2dbf0cce05aba6282aa3090b519c95584dc2021eaccecfc97b6c66c67ba4bd"
    sha256 cellar: :any,                 mojave:         "aa33dcb97455ec208315f8a3d57b904bfa98e219b705f3992776f167b08b35bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467c578adafbc5e93ae51017635192aa8696a642fe6ec458afce221092fc6049"
  end

  depends_on "ghostscript"

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
