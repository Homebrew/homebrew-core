class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.50.7/doltlite-autoconf-0.50.7.tar.gz"
  sha256 "f0b3bbf2a8a6191bbc256ed6ccb21bacb44208504c7891b902688c82713907da"
  license all_of: ["Apache-2.0", :public_domain]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "../configure"
      system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
      bin.install "doltlite", "doltlite-remotesrv"
      # doltlite.h is the amalgamation header; sqlite3.h stays out so it cannot shadow the system SQLite.
      include.install "doltlite.h", "#{buildpath}/src/doltlite_remotesrv.h"
      lib.install "libdoltlite.a"
      if OS.mac?
        lib.install "libdoltlite.dylib"
      else
        # The Linux library has SONAME libdoltlite.so.0; install under that name with the dev link.
        lib.install "libdoltlite.so" => "libdoltlite.so.0"
        lib.install_symlink "libdoltlite.so.0" => "libdoltlite.so"
      end
    end
  end

  test do
    assert_match version.to_s,
                 shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      #include "doltlite.h"
      int main(void) {
        sqlite3 *db;
        if (sqlite3_open(":memory:", &db) != SQLITE_OK) return 1;
        sqlite3_close(db);
        printf("ok\\n");
        return 0;
      }
    EOS
    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-ldoltlite",
                   "-o", "hello"
    assert_equal "ok", shell_output("./hello").chomp
  end
end
