class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.12.tar.gz"
  sha256 "55a7517cd3572bd2565df0cf450944a04d5273b279ebb369a895391957f0f960"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9356c5442a8707d6af5b3e90079cf2029bd957700472b1376714fd3c2249ce78"
    sha256 cellar: :any,                 arm64_monterey: "9ac5d73812cdc5686c83f86bea0b0006144a0632dcee49be757c1c95b4d87e97"
    sha256 cellar: :any,                 arm64_big_sur:  "d7a5e28e5563333b22a3f85212c6c983cea189954b9f53f9561cab95fc567e5a"
    sha256 cellar: :any,                 ventura:        "5021dd386f719ca41d8b7a749ce3bee5eb19d82d53b66743f276cdb132b2c36e"
    sha256 cellar: :any,                 monterey:       "2e41bab718bb8426de64d68c784993e77ab088c9cafd384f23c868c43f88f5ce"
    sha256 cellar: :any,                 big_sur:        "787acb27716e15096730040512928441e57c337e9a0a543d21f345fc6bf7785c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3514865edd037216507b01a0477484133c13189f04dc33512db7478ffad50d6a"
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
