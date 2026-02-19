class Qdbm < Formula
  desc "Library of routines for managing a database"
  homepage "https://dbmx.net/qdbm/"
  url "https://dbmx.net/qdbm/qdbm-1.8.78.tar.gz"
  sha256 "b466fe730d751e4bfc5900d1f37b0fb955f2826ac456e70012785e012cdcb73e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?qdbm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_tahoe:   "8758b4bbc07fe322baf1aeb4815956e31dfe20720429254f6e78a2e6c500acbe"
    sha256 cellar: :any,                 arm64_sequoia: "9983b409d48f7443900ce5b980b08f95e0f102854608c1615f4ff4f45b961f0a"
    sha256 cellar: :any,                 arm64_sonoma:  "445dc7761c805ee218c4a5d29b521338a9ba3d0e773fdddd0622b272b970cbf6"
    sha256 cellar: :any,                 sonoma:        "e972c7da4e44db7be3104ae998c53c23f3834aedba2eaf6a3169933327670571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8063229ce3fc0aac1e402f27c5f9c9ab27f7e1101006887aedc8047844b69fee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f532caae96d2ab1726eb1fd9196db93dd0b4511f9b407b209c545a801449877"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %W[
      --disable-debug
      --prefix=#{prefix}
      --enable-zlib
      --enable-iconv
    ]

    if OS.mac?
      # Does not want to build on Linux
      args << "--enable-bzip"
    else
      ENV.append "LDFLAGS", "-L#{Formula["zlib-ng-compat"].opt_lib}"
    end

    # GCC < 13 with -O2 or higher can cause segmentation faults from loop optimisation bug
    if ENV.compiler.to_s.start_with?("gcc") && DevelopmentTools.gcc_version("gcc") < 13
      ENV.append "CPPFLAGS", "-fno-tree-vrp"
    end

    system "./configure", *args
    if OS.mac?
      system "make", "mac"
      system "make", "install-mac"
    else
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <depot.h>
      #include <stdlib.h>
      #include <stdio.h>

      #define NAME     "mike"
      #define NUMBER   "00-12-34-56"
      #define DBNAME   "book"

      int main(void) {
        DEPOT *depot;
        char *val;

        if(!(depot = dpopen(DBNAME, DP_OWRITER | DP_OCREAT, -1))) { return 1; }
        if(!dpput(depot, NAME, -1, NUMBER, -1, DP_DOVER)) { return 1; }
        if(!(val = dpget(depot, NAME, -1, 0, -1, NULL))) { return 1; }

        printf("%s, %s\\n", NAME, val);
        free(val);

        if(!dpclose(depot)) { return 1; }

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lqdbm", "-o", "test"
    assert_equal "mike, 00-12-34-56", shell_output("./test").chomp
  end
end
