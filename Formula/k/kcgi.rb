class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi/", browsed: "2026-10-28"
  url "https://github.com/kristapsdz/kcgi/archive/refs/tags/VERSION_1_0_1.tar.gz"
  sha256 "d2b9f377ca31c3ac6ec47e7ec0f46b8f208a33ca80701777a20e355937fc5934"
  license "ISC"
  head "https://github.com/kristapsdz/kcgi.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "8145cd72feba0c5be9d464bbcba1403d4e0a4ed61bcd5540c7fa10610a75c214"
    sha256 cellar: :any, arm64_tahoe:       "0e11a41b99c2b97fc7ecb1c311c85346cc73d0345b56b8bfcbe7f1002cfa2936"
    sha256 cellar: :any, arm64_sequoia:     "fd5d7cb5c53271bd8a0fc6e6fe2bbcc9b9f86cbb1375e75533f9ad7a904627e8"
    sha256               arm64_linux:       "104680512dad607ab3b55e4e75fe9e2ef39c7285227ffc16dea475f5370a3659"
    sha256               x86_64_linux:      "d975de5140334d23c9d32ba0b835d7a4ec8f87a18cb5287b521e74e24d727e2d"
  end

  depends_on "bmake" => :build

  on_linux do
    depends_on "libseccomp"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
