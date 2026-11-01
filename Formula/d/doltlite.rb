class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.6/doltlite-autoconf-0.51.6.tar.gz"
  sha256 "2f65c5ff37a370c1b5230ea76c4b1967a23cd994d9dfe87b06cd8cd2a491047c"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "82df58869be2beba9372f3053fbcab529c9e6839138cb1c47e16910aa5b630c6"
    sha256 cellar: :any, arm64_tahoe:       "ff46887c50c12ca831a8967c0290c5df06efda2d7f4af97c7f6755466ff21213"
    sha256 cellar: :any, arm64_sequoia:     "e829c8ceed9aac9cc3acfdd5e68aad5a89196e06fe4c1d2cf780d5ae86e40a87"
    sha256 cellar: :any, arm64_linux:       "47a06fef98fca2c70ddfdc71fdd101487a278c9735fcfa9ff368e8950445bfe8"
    sha256 cellar: :any, x86_64_linux:      "4cdca62040ee15b3bfcc2ae344c3be0cd3a11b736ebbacbd7385e48156d0ae79"
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
