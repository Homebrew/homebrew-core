class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.11.tar.gz"
  sha256 "79d44d65f835c5114592b60355d2fce117bace5c47a62fc63a07f10f133bd49c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "15c599d638b613e5a478bdbc7f1a80c2e0d1227f268451452eaf80cc41591976"
    sha256 cellar: :any,                 arm64_monterey: "0045e0a03c25d49a3cff1d56651868c0c846da43740c546b2690f8bdce3aafd2"
    sha256 cellar: :any,                 arm64_big_sur:  "4e40717cf4aa9927062522049475f18f31155d2755ec55784adda88310ce0b45"
    sha256 cellar: :any,                 ventura:        "0095456a959fecb642f904f85f189fe201e2b1594b9603b2c401d7b9c15cd23b"
    sha256 cellar: :any,                 monterey:       "b2e8615f861c91e1f9f7d53902c78c98bd73eadebd5fafa95481b3e321f0b87a"
    sha256 cellar: :any,                 big_sur:        "d589840710bc56dc7eff27248facae9060bcd95de1d18e4507f0b9da63f6cc5f"
    sha256 cellar: :any,                 catalina:       "29202b71e2a406982108cf4dac7fbf0208526697939bc8a7e78b648708f64d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db3ddd37043fb3581e0d30b2b887f366daa5f263c918a41f53c3f944ecece151"
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
