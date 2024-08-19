class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.13.3.tgz"
  sha256 "1c13538e21511086a6ba1a87f40543de257fc3d8871840b17626c16d714d2f5a"
  license "ISC"

  livecheck do
    url "https://kristaps.bsd.lv/kcgi/snapshots/"
    regex(/href=.*?kcgi[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3a05d82cb4e3c9265061d0cf05872cf12c591d4793dc6b7114232fd3ccdc3614"
    sha256 cellar: :any,                 arm64_ventura:  "4a3714eb957ab3622c4eecb9add25a5e136971ad1030e32a712f08d3571efe94"
    sha256 cellar: :any,                 arm64_monterey: "34d3a40ea1e1ab174589142b356ef3a758cead1806f823fc4413babd7e29342c"
    sha256 cellar: :any,                 sonoma:         "b8a07a81577401eb7dac933817ab86d2cb62947c507cdb4697ddb49d3934681b"
    sha256 cellar: :any,                 ventura:        "b0adefa894690c1f14ea7cd1bbf8de7d38c628bcc5ccc31c3f281bd06c3d6e63"
    sha256 cellar: :any,                 monterey:       "72ebe7b1b8a88ec1b3567b05ff53200c37e6ccf88a434aac5ed8e39697dac8b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d9897e21cb8c9fe721e367847ddb11443b9793c73efe975c369e215ae0a66c9"
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
