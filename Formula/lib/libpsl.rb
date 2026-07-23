class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.23.0/libpsl-0.23.0.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.23.0.tar.gz"
  mirror "http://ftp2.osuosl.org/pub/blfs/conglomeration/libpsl/libpsl-0.23.0.tar.gz"
  sha256 "f39b9631b3d369a21259ea4654f8875c0ec6995ce9551c0eb5d423e4c011f911"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a716215523cb02acb8d85195e99aa540f8834f362054a700bc34b5b9d1983be5"
    sha256 cellar: :any, arm64_sequoia: "7908b0879d13ee965fb2c655afdf737bfd2fa166c07cbb498cbed0dd505fe7a3"
    sha256 cellar: :any, arm64_sonoma:  "847f1027dd6ef6c2f229e0f32159f85132385c941a7b96e80cdde6a30c5e6229"
    sha256 cellar: :any, sonoma:        "686d9ac516c5b02f3783b1787623e5dd370a911a4b7878236f9025daae15e7f0"
    sha256 cellar: :any, arm64_linux:   "628dba169e1539383cf2051d6f0d9f6ad29ec6a8af72b84c3511d4c41b239453"
    sha256 cellar: :any, x86_64_linux:  "6cd60a67781652b96fbb0570d563c25707c6788dffbea3ecf381eafc719999fa"
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
