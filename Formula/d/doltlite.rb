class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.10/doltlite-autoconf-0.51.10.tar.gz"
  sha256 "0763c478ac3a7b79a42c18259b05cc17e7ec9c72af9a3aaaa77dfc6baa10bdf0"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f05f474270f3bd90413cd14f66428b6a06b64ab9f9f309c75f817e0360a87e86"
    sha256 cellar: :any, arm64_tahoe:       "a257caef50c258985b3426c0f12430e4948871da2bfe739acf1f724b20eabf2a"
    sha256 cellar: :any, arm64_sequoia:     "5f6580f487f22b91ba36222f3d0f6f4ccc23c6c63778091435357dd4433a094d"
    sha256 cellar: :any, arm64_linux:       "c1f56f9cde6cc5a2f4a8abf83e08e839302f6c6ce2935714708afc806cdad6d5"
    sha256 cellar: :any, x86_64_linux:      "69c3c6ba73277e0c85896fb6a1dd744e5bc183f797628a8e2f36003ab670c5cc"
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
