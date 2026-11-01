class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.6/doltlite-autoconf-0.51.6.tar.gz"
  sha256 "2f65c5ff37a370c1b5230ea76c4b1967a23cd994d9dfe87b06cd8cd2a491047c"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca90287ced5a7915898aeabd40b5fd46a4d73b35543a3b6a75f9c593947cb6df"
    sha256 cellar: :any, arm64_tahoe:       "cc19c6433639e3acbe7946328422fb6ce5370f804da7fea36ed995bea972be7f"
    sha256 cellar: :any, arm64_sequoia:     "5666c5118d6185c10932bd868135dee7b1b81ab039357bb97f7f014b911878b9"
    sha256 cellar: :any, arm64_linux:       "37b5d2371fc89d5542752f18ce3e71b96736fedec3e84da22420d19653fc981a"
    sha256 cellar: :any, x86_64_linux:      "5609270d0194cbbafd7be70f6cf1a697d2858c9c515d83e64f05974c86f18fbd"
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
