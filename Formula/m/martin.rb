class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.14.0.tar.gz"
  sha256 "d75542ee0fa7f0f60975db856de39532035f981f187a6526b61f8b52e53e212b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee3b4f952f8227d10db721297d32102b64153a33b440afc724d1417cc682f9a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c7d8c103bc4772128041702320212792b1fcb2e61bfecd99f55c83fe6a96eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c35281bab783b578d9a54ceb5d8361e6b7e3999a866a687095b013198a16b8e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c29b086f846028fdadaa506048929e8eabb2189ee45d6f343c9b0a7378e9d68"
    sha256 cellar: :any,                 arm64_linux:   "aa8669d09ad258d13066e5c685a9e595315d4364ce55e2699d337a33cb02c599"
    sha256 cellar: :any,                 x86_64_linux:  "c0a8d3ab6b7df12570c8d35fb9e8bb21965145a1fd7916de08f2ab552ac61e63"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  uses_from_macos "sqlite" => :test

  def install
    # Disable `rendering` feature to avoid building maplibre-native from source.
    features = %w[fonts lambda mbtiles metrics pmtiles postgres sprites styles webui mlt]
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "martin", features:)
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
