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
    sha256 cellar: :any,                 arm64_big_sur: "569048e256adf2200f0d78bb9e0e69124bfc95d048942a7e7302021d4f26a725"
    sha256 cellar: :any,                 big_sur:       "dd24fcf3da06f8020b4c5439ca40d1b2eb17a518b62f205e8d34d4e259b0fd7e"
    sha256 cellar: :any,                 catalina:      "b6010400519844d7e3c0ead42e613279dcf301b69775bbc75f8e93c2cadf797b"
    sha256 cellar: :any,                 mojave:        "03c755d7c557ed3b53e73f398be9d2a04fd87143fa91d8dcbb010d8a36f313a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d02c4c372a70e15e3a180fc9f8abd855ec7d15086b1d3969aad657735156d0"
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
