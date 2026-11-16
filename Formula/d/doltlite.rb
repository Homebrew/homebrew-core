class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.12/doltlite-autoconf-0.51.12.tar.gz"
  sha256 "3d29aca3adfc85a1394adf7a03da159036467d135e421dffa1f08a4bce08ee03"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1743d2f713d9f559b651293a9933829bab189f19a01b9f1846e572b79ec055d7"
    sha256 cellar: :any, arm64_tahoe:       "6b3eb8283734baa4efea3d19753d6276d9c813652085603dc057a46da787b4a4"
    sha256 cellar: :any, arm64_sequoia:     "feb47c99f9a2d202231e395df2ea2b43e605f4d5e1acbfc029dadadb7cb2496e"
    sha256 cellar: :any, arm64_linux:       "204f4c73722bb9d454e993a8a2dc9c90dda2933bb35e86a7feb6f1535cd9b6ed"
    sha256 cellar: :any, x86_64_linux:      "bb0375e1688b94db0a351551f048d63197ad6d216872b1d7610e930eaa372c43"
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
