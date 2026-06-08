class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.10.1.tar.gz"
  sha256 "556f0701d0a584a6ce1953ee6f8b3a0689845f23e1e3c8d6712e5b007c4d8da2"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d77f6f3905ee81548180efca50ce536394fc7df592bbe660a1b5e561c8736389"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0763639b046334500c13826f524e85d9b729ee810cdc053931c0758b7c1324cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02eb81c9bd19fd5e8f0833be4f0fa7e30789f5b89a2bb497f66e039751dfe3ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac98b4f105eeda4e2dc73b7035d85719895f9350240027c4fd879e2eee69b3d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeec1188c9d620c1f552779c2224ace47a5b0154cd4ee00b367a73a76c7d76d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f07c2c7459f9648fbdb63b29633f6a99ade7e3d3353645474fdf150fa3868364"
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
