class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.11/doltlite-autoconf-0.51.11.tar.gz"
  sha256 "b88e2192a7fb0e0e04502556ec599799a510aa93385ef4f8bb002adcb22dde01"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "580aa32e113a68bf9388f0088419854a01c2daaf667b6a7c44ed59bbf7d6a4e6"
    sha256 cellar: :any, arm64_tahoe:       "cdb83e60e22a301d579b7c86e22e75c38627cfe719869578b1baa5923c8e7caa"
    sha256 cellar: :any, arm64_sequoia:     "8c0258b6610dad4fc54c5c35e8240f365cfc3281010a87c8e9074f93151a9ab0"
    sha256 cellar: :any, arm64_linux:       "a83c841893280279d4f53ff9be14aa014bfbf0fe7f1d7565b8a9ed14b7dd8fa2"
    sha256 cellar: :any, x86_64_linux:      "c36e9ecf56a429647daa789602834e8b8fd1990be17f201b1f1a240bf16be969"
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
