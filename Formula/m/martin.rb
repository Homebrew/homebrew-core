class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v1.0.0.tar.gz"
  sha256 "9cf1b84a11299be808ae8c304dcffe371aa5de482df97e674c5b1d1d004c97f5"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bc9b5b9e61440ad27e1c571f0014619256bfe87744f2da0524f767b4ea39ecc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60d070d7990ebc4fea0f27a55629eb0d163dc5e4f68b975aa43c617a655131e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd922c0356afd498c0aa941bcd662e88ffbb154146fdaad5fff0f9808cfbc3a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a81c2387ff62d07a943103be1f2b038cf1bd1b1c7b1817ae413aef3d8ef3f472"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32ff79a11dbdde412dbfa5023f919e411a8ee88ebf877ecaf19f88e97ec19a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76284966a16a8ed51fcef00fe567ba074302c7ee619bddf8e44d88cc262179bb"
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
    system "sqlite3 world_cities.mbtiles < #{sqlfile}"
    mbtiles = testpath/"world_cities.mbtiles"

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
