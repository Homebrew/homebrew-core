class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "61b495e96d6d75e9d65057c9b4c95ed78fcdab6dfa2b73424cbc930431e99e6c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b4a75b9f8a45f4b7dfa4707a90e96bce585678e9d5c656296378daa2c458983"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c8c7d65788f0ea4de8296dd12f77c9d77fa9bb46430203fe81af9e8a25d4bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "376af7adc40beb95536d5f81c0388990e648589ed8a7e73ea18a07d5e9087640"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6af305d19b8e5f42a5a8027ba21d439d03b896a7cdc077d77ea02973164a0ca"
    sha256 cellar: :any_skip_relocation, ventura:       "cd2e07c18243e83f2b9a4fd69bd97668dc1622ebe9036a443672c7ef867d845e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bc878acf47abfd4707863bf25f95e8664ba5630fca1a031be96a5fedb5ad0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096ed4f427aae8c109edc465abd166c17cb5ed29d941cafb13a627c95900837f"
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
