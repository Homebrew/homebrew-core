class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-1.0.1.tgz"
  sha256 "bc1cc29bca48eace5df4ba0f1aa1dfc2fe7ac773f750d4af84d80c52cece3c45"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "995d131805a53b35e355853a6cf3a7290267c591b50684c426ca2c14f78dbd05"
    sha256 cellar: :any, arm64_sequoia: "529d2e0848102f7cb852069560a5d361c93b16411325dea133642e2614b31d88"
    sha256 cellar: :any, arm64_sonoma:  "ee60acbe9c53f523840df57c559f14c78a58f585bb35f566de920d78e58cf60f"
    sha256 cellar: :any, sonoma:        "a420823399526dbc9384934a5347f75514f174e0000887619bd39075aac45fda"
    sha256               arm64_linux:   "edf49575195a7febbeb3a5e97151e2851d0554bf1f17a812cc9a962923712c35"
    sha256               x86_64_linux:  "18361510b90235c6579f72229c26b2eb9895910a80b63e075046c16f4a1b29f5"
  end

  depends_on "bmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
    # Uncomment CPPFLAGS to enable libseccomp support on Linux, as instructed to in Makefile.
    inreplace "Makefile", "#CPPFLAGS", "CPPFLAGS" unless OS.mac?
    system "bmake"
    system "bmake", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sys/types.h>
      #include <stdarg.h>
      #include <stddef.h>
      #include <stdint.h>
      #include <kcgi.h>

      int
      main(void)
      {
        struct kreq r;
        const char *pages = "";

        khttp_parse(&r, NULL, 0, &pages, 1, 0);
        return 0;
      }
    C
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
