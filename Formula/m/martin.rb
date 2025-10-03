class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v0.19.3.tar.gz"
  sha256 "0352758cb439bae89c110839b8f5500e3252dd1f5b419a22829d697fa23571ba"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a7062e4dc63f7184850b49300b1df3efa383dda05ae0e0de5ea7244b200f23b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92f7498d78ea3457c1eaed6231c5dc5982a1bb3bf254123142a02d8867ebc9d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6230edd0ad3a6d9aaff77d33855516ad46c1f88212b1c028544b1f0498dd7c2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9dbc84ae8a2fc8e4b6a3320c7b617b6f81ec28c3eb11616fb0272c303a70a20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da859427c0e67f30a2e62891bf983d516821b2cc1715b96ece62b85c7f01638a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea25c9496bdf3a6c0e44a7ae07e9f965f28cab082b149c4e6fe122a6b4de9e7"
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
