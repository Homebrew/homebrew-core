class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.9.tar.gz"
  sha256 "49ae9c52b5af81b405455c19fe24089d701761da2c45d22164a99576ceedfbed"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c102e3011101f5a181a88c276fba99d0f2cd1a951fb48d350cfd94bf0a5b3a92"
    sha256 cellar: :any, big_sur:       "57c4aea04a762a93d7633ea05e15a7b128deedb03ef87a7d2b3c1c429f01bba9"
    sha256 cellar: :any, catalina:      "3b6f844c11905a3dbe1c5a4b78c62416fd047c399be7dcb5887d9357a79a7802"
    sha256 cellar: :any, mojave:        "8bbc1229a48f1cedc29c54bd9ef15dca1e9e513e534b648e0ad8300c340e51e9"
    sha256 cellar: :any, high_sierra:   "53f4b9429b90c0dfe84a759bd21f26e668ea19143424d141bfe83fcc83e76394"
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
