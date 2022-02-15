class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.10.tar.gz"
  sha256 "cf60b2a80f6bfc9a6b110e18f08309040ceaa755210bf94c465a969da7524d07"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "feb7cfda3ee56fa06a53f733f68d69c7ae69cbde08469e9a2c074cb9191db12d"
    sha256 cellar: :any,                 arm64_big_sur:  "d534a89facbba541742df755c49b8fd1e3ccedda8aeb5b9428e7b818fa8dfb73"
    sha256 cellar: :any,                 monterey:       "9a070c179f2fea6f85c4638c0a5cff5543fdccb7fa9157d8c49ca3c8170da540"
    sha256 cellar: :any,                 big_sur:        "72fb8d9117c3922ac7bad067b974b45fe91ccabfe9396613d463be36d60033c5"
    sha256 cellar: :any,                 catalina:       "252cdeeb91d17de587e7b93cf9bdec8a1c5ae95f1ac4af6e0ad540f20a1b354d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ec982a240d4a7b5ced514c3842046e4beaf428595d3ec1b9575519dcf2b002"
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
