class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.6.0.tar.gz"
  sha256 "242000c076906b5b1f82283f91182cb0b2b9a35db6b97c880282c980c43cd3e6"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6aee3cebc4a5a8b5e2ac18fc549a209363718307f10375fc1fb0da428be37791"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63ce9a4231269c8e4cd2cfc0b72a0fb18fed965485c3ba72466af356e2142604"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54170477bdc1b7408adea20bfadc3351ac63974263bd2ac301892fad3e03674f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0c965875a6f89068ae85b1c048937e5505dd06d0a6c0f4c1feaea09a68a1a917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a77d8da6a79700ed00bd1e1192c7a311d6f2a57024511193dde46e9f0ad6577c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6acb2c7cabc4899d9a62355ee9d857264e8f7452ff5e8dbbec0f6c1a7d850d6a"
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
