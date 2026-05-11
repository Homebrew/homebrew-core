class Doltlite < Formula
  desc "SQLite fork with Git-style version control via prolly trees"
  homepage "https://github.com/dolthub/doltlite"
  url "https://github.com/dolthub/doltlite/releases/download/v0.10.5/doltlite-autoconf-0.10.5.tar.gz"
  sha256 "8918db0aab0e5aa41e627be6f2beeb55e528005b6317173213446453df44723c"
  license "Apache-2.0"
  head "https://github.com/dolthub/doltlite.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "zlib"

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
