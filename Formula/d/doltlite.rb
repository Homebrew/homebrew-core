class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.15/doltlite-autoconf-0.51.15.tar.gz"
  sha256 "d8553a2bfebedaee5ac1db55bd3c2a2cfa5ba62db8c25ec1f3452ba52df995bf"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    manifest_sha256 "8f692aabe848147f4e8e626afa5262feb8f94c0234dd1b4cb207fd538d855487"
    sha256 cellar: :any, arm64_golden_gate: "eae7654487314325cc74bdbc83c57dd0019c7ae4f5f86686f6afbaf448d96138"
    sha256 cellar: :any, arm64_tahoe:       "a2e91d1d7b2510b93cddfaffb1ece41af14682b44d1c0314cc9b0b1e427fc442"
    sha256 cellar: :any, arm64_sequoia:     "8d4fbba0ada0b8d429725a2150db07223cebaaf3b294ce9c03ec602845186bba"
    sha256 cellar: :any, arm64_linux:       "316e026ef2d2f0e7a70a67361208b62ccdc61b6e6105ede136d3bce39cb9b674"
    sha256 cellar: :any, x86_64_linux:      "1a70d51d7581590f16ffc9c08d84aba8e461c07dbd3babcfb7ed91b316260437"
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
