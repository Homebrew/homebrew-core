class Jemalloc < Formula
  desc "Implementation of malloc emphasizing fragmentation avoidance"
  homepage "https://jemalloc.net/"
  url "https://github.com/jemalloc/jemalloc/releases/download/5.3.0/jemalloc-5.3.0.tar.bz2"
  sha256 "2db82d1e7119df3e71b7640219b6dfe84789bc0537983c3b7ac4f7189aecfeaa"
  license "BSD-2-Clause"

  # TODO: See if Meta continues releases https://github.com/facebook/jemalloc/discussions/7
  livecheck do
    skip "archived, see https://jasone.github.io/2025/06/12/jemalloc-postmortem/"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e4143a4cc719df4053a6f3c77a92afc0c24444d305fe8a5f1be4fafa6771403f"
    sha256 cellar: :any,                 arm64_sequoia: "10573a40eb77f7ded7ce5825c5f03e3daf53ae04bd01670341418652bc84f0d6"
    sha256 cellar: :any,                 arm64_sonoma:  "d6eb24407abe8727ef33a295a9685ffbc3c89cd4772c95768575b76dc52d03e7"
    sha256 cellar: :any,                 arm64_ventura: "63744266dcd09077be2d6803f4f22b19826f9f088282f16ac227d580c6731be9"
    sha256 cellar: :any,                 sonoma:        "aad0662c3aa09d15cdff15575506efa347c8ea2d83fbd7b62d18df87c6825175"
    sha256 cellar: :any,                 ventura:       "8979f7acc83f0ac5c7d90b5071ed90b7f60a54237d2f9c43b0e8be6e5520494b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "397758abcc63244fc47ab9183027c9817c37d1d84620cb836049440de3a83147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "463bbcc1146e18ce0221638a152c6ee3f4820dc27b48b8cc1a39350778fca22d"
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
    args << "--with-lg-page=16" if Hardware::CPU.arch == :arm64 && OS.linux?

    if build.head?
      args << "--with-xslroot=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
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
