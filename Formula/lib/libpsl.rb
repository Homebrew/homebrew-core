class Libpsl < Formula
  desc "C library for the Public Suffix List"
  homepage "https://rockdaboot.github.io/libpsl"
  url "https://github.com/rockdaboot/libpsl/releases/download/0.22.0/libpsl-0.22.0.tar.gz"
  mirror "http://distfiles.macports.org/libpsl/libpsl-0.22.0.tar.gz"
  sha256 "c45c3aa17576b99873e05a9b09a44041b065bbfa390e6d474d06fbfaeb9c7722"
  license "MIT"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b9c0535f986ef73fc909a54ce8e3570e2bec530476d30fad5cecd6ae47205018"
    sha256 cellar: :any, arm64_sequoia: "e4bb0f02103334a3107985f0fe23618472874ad6b1ee4b414a20acf65bfbdc76"
    sha256 cellar: :any, arm64_sonoma:  "2fa11192a21d8b4e0931eeaaf0c50d45acbd5b23045af4b04c25d3bb00dc2540"
    sha256 cellar: :any, sonoma:        "9402eadd70dce0b9016917af3fa7335a334d272cae64b2806af7d180fcfd9061"
    sha256 cellar: :any, arm64_linux:   "ae00eeff50059921329ea872abb32b1e9ee9038ebce23cd6a3d903a3f3f8dcde"
    sha256 cellar: :any, x86_64_linux:  "4ef63f1349d8797f688d5552d911c4aaf55d6a0a640e92b25011132e1ffbadec"
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
