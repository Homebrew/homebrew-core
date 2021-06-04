class Kcgi < Formula
  desc "Minimal CGI and FastCGI library for C/C++"
  homepage "https://kristaps.bsd.lv/kcgi"
  url "https://kristaps.bsd.lv/kcgi/snapshots/kcgi-0.12.5.tgz"
  sha256 "06ed033de3723651d76e2fac1c2442aaa3a28ac231cbfda4142dfb8782cab363"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f822435b05a2e98b0bef784360c4e323ca7f6e9567673f0f2be4aa2f8e6d07b8"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3ab6c122f3a35e181334a51e35e7c0b47aeffeba14b70ed976555730a868111"
    sha256 cellar: :any_skip_relocation, catalina:      "2e3d7ae2a08b52f80bd995ff49f1ffd7c4c00e313555f47e6efe59e6ff587559"
    sha256 cellar: :any_skip_relocation, mojave:        "f0e30fd8df7fd51a6f1fca3e9067424002c0ddc57d9dfeffa24e55632a6955f4"
  end

  depends_on "bmake" => :build

  def install
    system "./configure", "MANDIR=#{man}",
                          "PREFIX=#{prefix}"
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
