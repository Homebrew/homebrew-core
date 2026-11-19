class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.14/doltlite-autoconf-0.51.14.tar.gz"
  sha256 "fea7c8087b51de11fe2814e467f99e347a094cdaab37ff4e7ae344466af46ef1"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a37470c2109a79568abee9aecb2c01519b70a28042f75d27dc56831ce533d041"
    sha256 cellar: :any, arm64_tahoe:       "9d41361d52ae17b5cf92e064b3c8ef4f1e9a0f4245fa0ba0979453abaf00ad76"
    sha256 cellar: :any, arm64_sequoia:     "6d532c0387e78763ecc9167e6e6af3abeb835fb17ef803e85d6cfc49d3bfa200"
    sha256 cellar: :any, arm64_linux:       "fc70a4c2fa239e27350e59219027970c15af711af3c5d6ff4ae6a7c305222cd5"
    sha256 cellar: :any, x86_64_linux:      "f63fc4ae97087aa2937929a571ae58506cf247a2329dbd944bbe13facda6379f"
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
