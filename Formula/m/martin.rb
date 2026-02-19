class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.3.1.tar.gz"
  sha256 "67e4a090f422a1806be7410b1d196a40051180bae65b0a1ced217d4ffae2eaac"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "51d3c6ca938ad5ff7c980d95332b10c43a7ceb6313aea0c4bb24183ee8fb50c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f31fe6b7529a56d9c14a3cf7b836973d0f6e9e16db6ef6b01817f10a87e190c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "912d6319f85ba624eaf9021c1f83dfdbd21629245246f9cb6ff4273dd1af2dad"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6a8b40b4e56b46f99d6936f063908244e2b502f75b4fac951b6f8b6b25d87ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cdfffbdd1b0fd3b5d4cac6c1cac609ce6311b2cb11c9bb6edf6f8b7f7cdd0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3859d31801611890b2706e95b9d074884b321728e08809f6aace4222320fee"
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
