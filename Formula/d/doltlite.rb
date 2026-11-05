class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.9/doltlite-autoconf-0.51.9.tar.gz"
  sha256 "ae6a44cab882de9e6a34b9aa6c29ae1c6f7a5ef2a60f3f48b6ae13be9cd2a47f"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "184edcfbcfcf57119a0de6da2a4aaa4ebd542d3d1b6812e64f7755f0e4259923"
    sha256 cellar: :any, arm64_tahoe:       "6a53307241f1fdd990043887ce0df4245ae036859f8b74c64c51f49e1abd5b41"
    sha256 cellar: :any, arm64_sequoia:     "f9c8a2762846c0dc70fb30e5f71670c8e3ab52a2c91d2c440fe3c4219b9ef43d"
    sha256 cellar: :any, arm64_linux:       "702e3e2774a3d14b6f7bf48fa7ae32cff32eb7f3f4eb1f4ee01073889f1760f0"
    sha256 cellar: :any, x86_64_linux:      "92fd274c914ce42e5edeac26da16ac770febf02dd61a66f2bc99e1718b1a3dfe"
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
