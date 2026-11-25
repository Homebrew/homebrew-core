class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.51.16/doltlite-autoconf-0.51.16.tar.gz"
  sha256 "3b2bfdb51df7c4bf519f8361c674d7f70290997102104b262ee0394aa30e0559"
  license all_of: ["Apache-2.0", "blessing"]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  bottle do
    manifest_sha256 "284bd6bf94ec050ccca6d953dd89dcdaf3381981206724f207a7c64ac775b8c5"
    sha256 cellar: :any, arm64_golden_gate: "03df12b22c20d47070abae2aeca33eaadb1cf14e48526d2cd5e8e9dac4789a0d"
    sha256 cellar: :any, arm64_tahoe:       "2935f8fa6819dec25fe4b45daecd60c61f846e694613bb390589ef1adf74cf1f"
    sha256 cellar: :any, arm64_sequoia:     "8276533423136d95f6e1867d9144ea02d2e1b185fcd6d802334a6c29cb80502a"
    sha256 cellar: :any, arm64_linux:       "5f026dc2b45cefdb12df50662a34276e735bf16fc2ac15202f1bff747d8303b8"
    sha256 cellar: :any, x86_64_linux:      "81913224680535b9028b4d51f979e001d905f1defd565dd9a96c61f31cbbae46"
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
