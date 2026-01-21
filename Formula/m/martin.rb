class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.2.0.tar.gz"
  sha256 "5a65477a5d475c929015b9e08ad4bd1a78995303e1c2a3477f54cf04e3005c3f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10146de1ff2f39d020f1cfadec688c29b0f0e9c7349e672c6ea22a33fbb2ff08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e483ac47e9e7bbbf9a69c6eabfcce45be761a6286894fbeaf27aa47cf619c4c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6d69d1440e7b59c12e1e61fd7ecd7a46bd074553d9d12c489914f56e8cbb6b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0abc0d2b85926fa4f47c4299f69049fae4ba51799e0b31433d4744c19b0850ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8202a750735188cd1568a91422264fdf18112c1da43189903f957abaeedbfb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7500616596aa434bc371bf9ed3c346bea53839d09a44da51f522d80942790440"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "martin")
    system "cargo", "install", *std_cargo_args(path: "mbtiles")
    pkgshare.install "tests/fixtures/mbtiles"
  end

  test do
    sqlfile = pkgshare/"mbtiles/world_cities.sql"
    mbtiles = testpath/"world_cities.mbtiles"
    system "sqlite3 #{mbtiles} < #{sqlfile}"

    port = free_port
    spawn bin/"martin", mbtiles, "-l", "127.0.0.1:#{port}"
    sleep 3
    output = shell_output("curl -s 127.0.0.1:#{port}")
    assert_match "Martin server is running.", output

    system bin/"mbtiles", "summary", mbtiles
  end
end
