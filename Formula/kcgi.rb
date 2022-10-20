class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.13.0.tgz"
  sha256 "d886e5700f5ec72b00cb668e9f06b7b3906b6ccdc5bab4c89e436d4cc4c0c7a1"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94328c333800419711f54bb6bb199c632e8dd665dd04f8fdac22d54a2391c2fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "477a66993f541e9b595996d577c766c5eb205730b97885853322b32bb3d66285"
    sha256 cellar: :any_skip_relocation, monterey:       "d8559957ace2184733fa9d74ebee348137efa4093e6f07b5c907cc924aaa1532"
    sha256 cellar: :any_skip_relocation, big_sur:        "aea0950090e27a079ea4f104a726676c13f01de6c56284b2f98e8bfd1a208e21"
    sha256 cellar: :any_skip_relocation, catalina:       "de0d79ace2d35397df1fa1e8d7e09128372d9c7989992675ae835d2d21a502e8"
    sha256 cellar: :any_skip_relocation, mojave:         "a4779378456da9d3887e45136c69df85d47bef12d57b7f8903f840f4c2b12002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dbc844befbf8fcff4b08055dd7c9964ece3e846b6d0bbd6282663ebd89a6ff4"
  end

  depends_on "bmake" => :build

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
    (testpath/"test.c").write <<~EOS
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
    EOS
    flags = %W[
      -L#{lib}
      -lkcgi
      -lz
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
