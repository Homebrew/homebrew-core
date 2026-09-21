class Jemalloc < Formula
  desc "Implementation of malloc emphasizing fragmentation avoidance"
  homepage "https://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.4.0/jemalloc-5.4.0.tar.bz2"
  sha256 "200776fac271093e7c2f21edd6d62657ecd2be578d9328633f2a86bfa6ef4f1d"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ebc856c594fac98560d03ee45b1a74dafc7564cfd1cc54223c717b8976697096"
    sha256 cellar: :any, arm64_tahoe:       "2d6b12cd49be74b19e4fbae76ee7d7cb8b9556bbc3ee8a16a001742ab866675b"
    sha256 cellar: :any, arm64_sequoia:     "100f278db6678ee5e3487e6e56c679759739195010755498d2c25d5f9013b6f9"
    sha256 cellar: :any, arm64_linux:       "c7783f196bc57093dfbd6c1eb0a9c146b5cef2ae2cfabcf7d2972f3a4060a51a"
    sha256 cellar: :any, x86_64_linux:      "6c66c4b42238fe1015bd74f76efdc03e9f745590c03502a237028a0c7fc05981"
  end

  head do
    url "https://github.com/jemalloc/jemalloc.git", branch: "dev"

    depends_on "autoconf" => :build
    depends_on "docbook-xsl" => :build
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --with-jemalloc-prefix=
    ]
    args << "--with-lg-page=16" if Hardware::CPU.arm64? && OS.linux?

    if build.head?
      args << "--with-xslroot=#{formula_opt_prefix("docbook-xsl")}/docbook-xsl"
      system "./autogen.sh", *args
      system "make", "dist"
    else
      system "./configure", *args
    end

    system "make"
    # Do not run checks with Xcode 15, they fail because of
    # overly eager optimization in the new compiler:
    # https://github.com/jemalloc/jemalloc/issues/2540
    # Reported to Apple as FB13209585
    system "make", "check" if DevelopmentTools.clang_build_version < 1500
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdlib.h>
      #include <jemalloc/jemalloc.h>

      int main(void) {

        for (size_t i = 0; i < 1000; i++) {
            // Leak some memory
            malloc(i * 100);
        }

        // Dump allocator statistics to stderr
        malloc_stats_print(NULL, NULL, NULL);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-ljemalloc", "-o", "test"
    system "./test"
  end
end
