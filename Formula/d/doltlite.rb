class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.7/doltlite-autoconf-0.51.7.tar.gz"
  sha256 "2a523faa08aa9f236b3a851cf9a311b254dce0b6ceb960429906fdbb5602c3d8"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e26f6ec9ce3ce9226158234bb53ed73aee2b3fcfe0ef06fcde12d82e80f01f57"
    sha256 cellar: :any, arm64_tahoe:       "c569cc75f6803909e1b6766a31b0f82642ce0715ce7295cee630be6461d6c0cc"
    sha256 cellar: :any, arm64_sequoia:     "1d94aed68428af7264b296a06f0b6794ce201742ab13c696b81afaac21e6a93e"
    sha256 cellar: :any, arm64_linux:       "1851ad8c63f80c0474a06acc2ab398ef7ab8f038615e14ceab944e4261daa6a0"
    sha256 cellar: :any, x86_64_linux:      "8ae86b7170c19783feb5c1f74ae200716d5311dc5bc6e7b723b5a273f5f2f303"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
    # `make install` would also install `libsqlite3`, `sqlite3.h` and `sqlite3.1` from `sqlite`
    system "make", "install-shell-0", "install-doltlite-lib", "install-doltlite-headers"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")

    (testpath/"hello.c").write <<~'C'
      #include <stdio.h>
      #include "doltlite.h"
      int main(void) {
        sqlite3 *db;
        if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
        sqlite3_close(db);
        printf("ok\n");
        return 0;
      }
    C

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-ldoltlite", "-o", "hello"
    assert_equal "ok", shell_output("./hello").chomp
  end
end
