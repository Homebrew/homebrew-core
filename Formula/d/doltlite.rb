class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.8/doltlite-autoconf-0.51.8.tar.gz"
  sha256 "e7e8af3521b2b662dce68ab60cadc8b8fd7fa43c70c7648ed7aa2cd73ceab503"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef97278b374a9f6fd19678b02b0c45b3d9b1280f0d327dde6a6ba54865b2a05c"
    sha256 cellar: :any, arm64_tahoe:       "b158166ba114a0e1af4c158521e18faca5bc6a739135a56f39c84567b9ef57ab"
    sha256 cellar: :any, arm64_sequoia:     "6acfbc46a2bd0e26c6491c37286cd0e8e6f13f8369a4e2013021d0aa88a9e34d"
    sha256 cellar: :any, arm64_linux:       "09f09b2a1963be0ff8ea46c85a8b855acd7c71dc79114c2add56b85e3ef400e1"
    sha256 cellar: :any, x86_64_linux:      "1cbadd8cc14e64a4792b228e04a6bd6f75e26c8131db9d1bf0d156b8b15726d4"
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
