class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.12.tar.gz"
  sha256 "55a7517cd3572bd2565df0cf450944a04d5273b279ebb369a895391957f0f960"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb745b0fbd3bd844205f3433c65bf0668487927d3faef3bd13250f7303f010a5"
    sha256 cellar: :any,                 arm64_ventura:  "982e8f1996c44e7e473a141ffc5cf370405925f9a631c43b4a48da9e575c2b8f"
    sha256 cellar: :any,                 arm64_monterey: "842d9762ba3438664feea6d163ac837f650ddb2f6f87d7464d90b6de4f070e3e"
    sha256 cellar: :any,                 arm64_big_sur:  "e7eb36d1be8871a6c1b3442dcf77b0a1f7e0a33d5e4db59853fc603a62f742a0"
    sha256 cellar: :any,                 sonoma:         "91965c40959e93bc19589acf6ebd5460bb391d7386905f1cdb9030ac55a99dbb"
    sha256 cellar: :any,                 ventura:        "ea5c3404dc8e5e55a1f6a386e1e4b7a34718b99a1906f7f3a378df290ad120cd"
    sha256 cellar: :any,                 monterey:       "7247bdd2974cd294ff3e4139bf5256f0d3c202c023d68a953f8f4491cece3e3e"
    sha256 cellar: :any,                 big_sur:        "ac90c238075466686c5c6ed59a8b4dd0135f2b3db6fcb19a7cd865f4f11dc156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8f8cdf6315633ce8dfef6a5b0078a786ca06219aa979f2f6f1818033a54203"
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
