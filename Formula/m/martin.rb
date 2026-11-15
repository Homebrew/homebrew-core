class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.16.1.tar.gz"
  sha256 "e64c4c43af3eb5940c825c70619f6c670e7af4a5853498c39237b6b7e57e42a2"
  license any_of: ["Apache-2.0", "MIT"]

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1799b5a32a4bc064cf36ad982d1804d02cc17db89773a07b706aee6b458c5283"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ce143aad121e6e79eb7906512da140b2f530951895b3a0fe54b489a3158483e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d24d27284df5223493c6e7c51b99a96ccb5c1617034abc0657f8c3df97a1dff2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7b94e1c951b46134b39189689909fe704f4c32a516b91a57c08982381ac2b405"
    sha256 cellar: :any,                 arm64_linux:       "04c51c13e635dd83fb44a5c2dfb2bfb2637127240d63633c737e439c461d26f5"
    sha256 cellar: :any,                 x86_64_linux:      "513211b43540ad756186a9dfa168b3a0b3a40bb19cf36079e3fe7616dde242e3"
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
