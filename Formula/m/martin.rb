class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/martin-v0.19.2.tar.gz"
  sha256 "9dbe9dc4793b04c75f55145712eaf0619f7f282e620898ad896800461890809a"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^martin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c6eb9c526c13e8a3ac68526a12a1a9c022d215777760b9e7b027b759c5ee9c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ef036358414e70f5a7611b8aeba195ba57c2aaa607eafea83ced4782c41748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db8fa267dd806b0319dcc5ac83886cabe030af6e6dd94e4cbeab87d2f74a5da"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c4d61a42de628c1f0d51688fce8ad45deeaf73688559227f2bbcbfcc9a1c5c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29e446421b92368887463a928f5e1fbd9584b0c0be2ef2fca77ce4c9b2401784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ef975a5961fc98cbd4026bedc2384ee9bfff0ee8b157f381e903b717fcf8cad"
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
