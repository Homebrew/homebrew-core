class Jemalloc < Formula
  desc "Implementation of malloc emphasizing fragmentation avoidance"
  homepage "https://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.3.1/jemalloc-5.3.1.tar.bz2"
  sha256 "3826bc80232f22ed5c4662f3034f799ca316e819103bdc7bb99018a421706f92"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5040904022a39fae26c7da8fed26596b15a1ccd88ac8a1335e60311a4a7de632"
    sha256 cellar: :any, arm64_sequoia: "c0e6201b5be8ae36eb3aeecf2bb2a616860089e637979ab6bf238ad74aebc3be"
    sha256 cellar: :any, arm64_sonoma:  "0616a2e0a342d8f28eea75db184bdd21f9ab3855530192e4b50e8c5130329959"
    sha256 cellar: :any, sonoma:        "0783dba303dacc3110b7a15df15c7567a144ca99994f1e69ee1419eb4c75e8bc"
    sha256 cellar: :any, arm64_linux:   "a80a49c1e8d92bb5bf08b74841fa4fb15ea4d4d3069a40dbfba4bfc77cdaaaae"
    sha256 cellar: :any, x86_64_linux:  "e3a515d40e76209d400bb170515fae4f25b6ca09736fec178af32654f5aa97b3"
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
