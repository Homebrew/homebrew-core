class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.12.0.tar.gz"
  sha256 "5dcb6992c4c0a05d6e1913dd8191021ce3f9c293693aa130003cfd21e5f96e9f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d56d46f3885adc7c978645859f4ccdc619e6801cf94ac50cd972ed1620fb4ae4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c971820b07d77836cb573fd0c0e74606d5e3d5413e50a7716c0bc2cb914c73a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2a9c7668c5446a5a7359e1938a43d81d8c3229fd85728f565ea8c0a117c8054"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9ee03cf2258242aaf358d47c29ea16993e0142d2c35ed571e5543435d76573d"
    sha256 cellar: :any,                 arm64_linux:   "7cc6877aace33d818b87267b1e89dd03a4ed46d5ef8e99585ae9991891f27b10"
    sha256 cellar: :any,                 x86_64_linux:  "ab690572cd3b80bb3d4c6af1a7316c19b96b654ff8e82d24aeb8d9dfe0c5173e"
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
