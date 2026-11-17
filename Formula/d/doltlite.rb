class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.13/doltlite-autoconf-0.51.13.tar.gz"
  sha256 "fe14167bbf61035f4111e676c7cc4f150c2cab7daade82bba8064703dd79009b"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2606817679d06842e772061116ee40d4e21a5b0b1a88e3ce4fa23c1229875888"
    sha256 cellar: :any, arm64_tahoe:       "4b2bc070f24083270921e98afcbebc97678a33d63be0f2f76e8436feed7470c7"
    sha256 cellar: :any, arm64_sequoia:     "5941f159cf272405be148420c0dd35114c3ec8cdc89843128051d69b2030dbb3"
    sha256 cellar: :any, arm64_linux:       "f3bd7aea4cc3b33bdd159004c0756c0874a1cce9631f41d1be2a3b0563d65b64"
    sha256 cellar: :any, x86_64_linux:      "050f378758669551d45c7a7f51d707374e40c986e08b817914a47fa2590b38c7"
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
