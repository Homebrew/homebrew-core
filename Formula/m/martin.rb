class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "1308d9f0d83f3b645875380aa784949ff9b56847a60384751e656291e60111f5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa78b7697adbf2c7cad5f1cd2cb7dfa070fb241c950ef61fe2e947f293154429"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29e5b6b7ef944ef3a02ef7882a4b52aa053f5ed91fe3a9a106e16f227372d8ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7944e7a446b7400d4e9b22c2b2fb3a44442b15b8355e7ae5dd7b715cd68abc20"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bc131c8c10971a4b96a7ccab010755887e76c1de2ce70e4b4f76867efa4117f"
    sha256 cellar: :any_skip_relocation, ventura:       "f1f8a0f1024a24c0fc41c625da2cfb12848ab1bb0edb758e88abf1c3a55b8366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca011be64c545a210d401aef700a3181f06fe34ce280d0cd5aa70f895f8703d"
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
