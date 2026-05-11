class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.10.6/doltlite-autoconf-0.10.6.tar.gz"
  sha256 "816ecedc369dd61fd06a0759985d5fbfbdf9fadcd1096cc1c35cc7f09447e7c3"
  license "Apache-2.0"
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
      include.install "sqlite3.h" => "doltlite.h"
      lib.install "libdoltlite.a"
      lib.install OS.mac? ? "libdoltlite.dylib" : "libdoltlite.so"
    end
  end

  test do
    output = shell_output("#{bin}/doltlite :memory: 'SELECT dolt_version();'")
    assert_match(/v?\d+\.\d+\.\d+/, output)
  end
end
