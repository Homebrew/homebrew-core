class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.23.3/libpsl-0.23.3.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.23.3.tar.gz"
  mirror "http://ftp2.osuosl.org/pub/blfs/conglomeration/libpsl/libpsl-0.23.3.tar.gz"
  sha256 "93941f85a1e7bd593fa94f299233cb5dfc91cd144fd9a78a6ceb75001c5b03be"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3058120ea617a1ba193463788e81b8afd08fcf0abdbaf0bb5bfa85eebc695761"
    sha256 cellar: :any, arm64_sequoia: "392f0aceca4e4febcb583688fa4bb701853e4a41a3d11446b0deac5231c32a53"
    sha256 cellar: :any, arm64_sonoma:  "c26c327af497356f04a3f818da2d073a7f9833a7494231d8808b85599e029bbd"
    sha256 cellar: :any, sonoma:        "a8461dfee9fad01788669d0afbdcfd92c112708e220c4a8a371c3cfca3da1b8e"
    sha256 cellar: :any, arm64_linux:   "939526d6284bf9296521d430a86e30b9226bd0618a558a0a58e5c2729b6f891e"
    sha256 cellar: :any, x86_64_linux:  "31ef3766b6b2f2c78a82e9f8b1d902e06d03ec33e1170694e298296ad7c3fba5"
  end

  depends_on "pkgconf" => :build

  on_system :linux, macos: :monterey_or_older do
    depends_on "libidn2"
    depends_on "libunistring"
  end

  def install
    runtime = (OS.linux? || MacOS.version <= :monterey) ? "libidn2" : "libicucore"
    args = %W[
      --disable-silent-rules
      --enable-builtin
      --enable-runtime=#{runtime}
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <string.h>

      #include <libpsl.h>

      int main(void)
      {
          const psl_ctx_t *psl = psl_builtin();

          const char *domain = ".eu";
          assert(psl_is_public_suffix(psl, domain));

          const char *host = "www.example.com";
          const char *expected_domain = "example.com";
          const char *actual_domain = psl_registrable_domain(psl, host);
          assert(strcmp(actual_domain, expected_domain) == 0);

          return 0;
      }
    C
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lpsl"
    system "./test"
  end
end
