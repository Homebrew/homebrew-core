class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.4.0.tar.gz"
  sha256 "ffc0a2d99e5bdace7c1a13102e3f45a674a0f84d5b6238d71c599246d68da969"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "685579fc05af1351af3722ed908d117c340968a3aeb87ac9fdd65185a3a7ae89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "236e3c1a6ee52bcd53087662c2ffa5d6b488325384c00fa4a8d4c017966bd9f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "437632f06045502c6675abd2e5c466eb9224f08789958b77dff5bee22616a746"
    sha256 cellar: :any_skip_relocation, sonoma:        "70b6ac4f29848a9d86d91dd18c8d24e3c940ce4dec1c9d0f4dbc2388dc255a14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a886cf90f3bed1cdde0c92b54a6772630a5f93a7d146bc89e4ca0963ac5c9594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be97e17dae256057685a7b5c4a61523692ffc2e51641fea403288709ea7e4e55"
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
