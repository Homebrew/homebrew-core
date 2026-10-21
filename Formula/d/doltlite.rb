class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.1/doltlite-autoconf-0.51.1.tar.gz"
  sha256 "751ad69aa6d2547ef5c05686ef66f119fcbbf79eb26c315981d7aaaf7d7f84ce"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a7c6814cd0793d663ab86283ba33aecf51ee473e2c45fa41a2f004e64d4f7ec0"
    sha256 cellar: :any, arm64_tahoe:       "d48c294028cdfc7264da108a1f0f440124bee346e9e40fcfbe4c61bfffcbc42a"
    sha256 cellar: :any, arm64_sequoia:     "fd98729f99962acbf27fb3668bfdc3f6e766e4c9d70c03f54c50ce1e70f31324"
    sha256 cellar: :any, arm64_linux:       "71bc0424131713ddf569294c22bd86d637eae9aa05a1d4637b1ad9251296725e"
    sha256 cellar: :any, x86_64_linux:      "157e600b7812985d1736746e61a55e86396254b2f8d4059bcb1c13abd78cc3c9"
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
