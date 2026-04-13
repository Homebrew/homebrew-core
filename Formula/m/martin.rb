class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.5.0.tar.gz"
  sha256 "a2d93361260cd058cd72549b8aacf993ef0676d23456c2f7fdf9096677bf653c"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02bd087472bc5d880a96772fffc75ef00fa16a19783fe72a5922f2383d8dd98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94ad77163a5039dcf8094112033ed2a881ce9b383ad5a6fff77b18aa05601dd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b0f6fb090b3a18042a7f5fe783c44ae8cf4796bf7bdd1b21bb147175f134f47"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a22e8bb799e7dd9ddcc21020521694355c5794fe9dba45d5b5bd9fbc04d4b23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1a88b5166dfce0a4c70cf20dfcaff90084b6993dd49680f9569419ad4fa6682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608e2b4f216e2c34ddcb892089177b1d252db42f211213d4e81854a78eb21bfc"
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
