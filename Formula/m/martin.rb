class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "45ba255464607583f71d692989d54ca557c7595a900ed0600c02d1695489e507"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdf8a4dbd81d1e71ddb760ec3abad683cf7ac6b80bca2e89e112c485bb3f04a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "952a48e9ffb9018bb8b705b59c353352fcf8ae66685ee129159a96e96ef4ba89"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f12ed21d38f2015f688ec434c119be73a30887d48c5b2b293a765ed8a39c8f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b317b6efad68b7e530854b586907ddc2a8cba57e23e4706a1a19acf730ac28ef"
    sha256 cellar: :any_skip_relocation, ventura:       "f76bf5cadbfbaf80150402e3b61a5a91ff7651de783fb018d706322125c59d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97113c097cd49add4114998a89ec8feb1cfb97c57585c81d7506b98ee5b64da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65d54137e39a352ac5722e2bfc671af4c1af017fe07b45b4874103d4ea208193"
  end

  depends_on "node" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "martin")
    system "cargo", "install", *std_cargo_args(path: "mbtiles")
    pkgshare.install "tests/fixtures/mbtiles"
  end

  test do
    mbtiles = pkgshare/"mbtiles/world_cities.mbtiles"
    port = free_port
    fork do
      exec bin/"martin", mbtiles, "-l", "127.0.0.1:#{port}"
    end
    sleep 3
    output = shell_output("curl -s 127.0.0.1:#{port}")
    assert_match "Martin server is running.", output

    system bin/"mbtiles", "summary", mbtiles
  end
end
