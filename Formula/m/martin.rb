class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.11.0.tar.gz"
  sha256 "08b794d9bdbf7eba6e07de64d892397c8c0bcfb73bcf41fbe83f3cb7c9c36d25"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40f11196bd81a465e65257b3d8c85bec2188adb896cd2cc76109641a106a3c5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb73a0e65e11e5aab564b6c19f7a37e1fb3cf7523189bdf0934a7b541b147b6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5222cbcfac56dc580514c8c87cb51b19fbde0605136f10a61c772e9d1ece1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "5318c5179622f028c54341e0947a3ae094c753e5d1ed1f2ce98b1754d98cfecb"
    sha256 cellar: :any,                 arm64_linux:   "192745d76549ab1fe468a0ea170d8dd71e1bd56de9c0781adae1ebd37bb10089"
    sha256 cellar: :any,                 x86_64_linux:  "072226a8f06fe13791fe037eb060a90504ed652482191941b403d486d3ea511c"
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
