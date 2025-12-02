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
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "5222aa09e8299b7db382992f7630bd0881e928823e961c2033535adb2b4c95a4"
    sha256 cellar: :any,                 arm64_sequoia: "93ffe465aedaa92b472c387fcee97ce7c8611b32aba5127cde60558746aed441"
    sha256 cellar: :any,                 arm64_sonoma:  "5f9e5e025feda86f511d850b0af43d251f52637aa1bfeb3428b5cbd0a23df7eb"
    sha256 cellar: :any,                 arm64_ventura: "2b37f6d105b64d9320f71ea174c959d8d8df01a70805662be04cf5b54eb73ffa"
    sha256 cellar: :any,                 sonoma:        "e9f9b7bb82d908e6278be6164b85495237decfab1548b3c65e7856e873bf7c1c"
    sha256 cellar: :any,                 ventura:       "77d8ac2179ec650753482086110e5907bf9535647f9d3b3dbe911aba0327d292"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52710b49798647bb9921dedcb31765f7245e53b6c9e858bce89604f679ed610"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d63d9159c7ec417881369e52b6d4da71982b91487b03fb5d73280670296fea90"
  end

  uses_from_macos "zlib"

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
      ENV.append "LDFLAGS", "-L#{Formula["zlib"].opt_lib}"
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
