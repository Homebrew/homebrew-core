class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.50.3/doltlite-autoconf-0.50.3.tar.gz"
  sha256 "fbe66215a3f214d92d1edab82d7125df8257690844541f9a75a3bc6435c2d714"
  # Composite, and both halves are real: the DoltLite extensions are
  # Apache-2.0, the SQLite code they are built on is public domain. Stating
  # only the first would misdescribe the tarball this formula builds.
  license all_of: ["Apache-2.0", :public_domain]
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "../configure"
      system "make", "doltlite", "doltlite-remotesrv", "doltlite-lib"
      bin.install "doltlite", "doltlite-remotesrv"
      # Install the embedding header as doltlite.h only. We do NOT
      # ship sqlite3.h: spoofing the canonical SQLite header path
      # collides with the system's sqlite3 packages on the same
      # machine. doltlite.h is the same generated SQLite amalgamation
      # header under our name. doltlite_remotesrv.h declares the
      # in-process remote-server API (doltliteServeAsync et al.).
      include.install "sqlite3.h" => "doltlite.h"
      include.install "#{buildpath}/src/doltlite_remotesrv.h"
      lib.install "libdoltlite.a"
      lib.install OS.mac? ? "libdoltlite.dylib" : "libdoltlite.so"
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
