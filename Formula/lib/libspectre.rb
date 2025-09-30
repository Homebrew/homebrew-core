class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.12.tar.gz"
  sha256 "55a7517cd3572bd2565df0cf450944a04d5273b279ebb369a895391957f0f960"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "827462a01392f7b4ba24ec5b45ea4aeee0e7e0a674efe43d5b0e52ffeb150bf0"
    sha256 cellar: :any,                 arm64_sequoia: "d9e00969398b5ccd244aed543e3a6468f56e07dbc1939d7bde6b4b9d19701001"
    sha256 cellar: :any,                 arm64_sonoma:  "c7ff644160fb7011b2eeba6c07102db37b587c1f80631f4f2abdd81dbe476dcf"
    sha256 cellar: :any,                 arm64_ventura: "aac4fe3f1a81468053f6652fd67dec5416b759b86060a5e62cb804f5ed4bb6a2"
    sha256 cellar: :any,                 sonoma:        "ef295c014933eb73252356d5f6ef9fcbadacf864fb02335c232f3f109d9c1733"
    sha256 cellar: :any,                 ventura:       "5c11e5bf8c575510008c9d7f3cb0cd540d35897521a70d81fb30eb0099bbf658"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "826f5672b813a31c1d4b8ca84c8f32adcaf053bd46773446df2080ba0352c6d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "749030918fe30fbba3b0332ad978765f638c0ce4b1a79b26cf8a632c10631cb4"
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
    (testpath/"test.c").write <<~C
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    C
    flags = %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
