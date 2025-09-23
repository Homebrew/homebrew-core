class Martin < Formula
  desc "Blazing fast tile server, tile generation, and mbtiles tooling"
  homepage "https://martin.maplibre.org"
  url "https://github.com/maplibre/martin/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "44ce3c98b44cec0dc6526843d2f7868de54f89aed128316fc9e7044734b1a111"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11b453a57cbf3d5ee140846b9e2199af451c31c984e755d8ff5c1dc324e79703"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c337fc6b6ae0dc8f88075f778fae3b7fc47ca00a4ba0b71022b74bde6805f1e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4052fe66ce49a3613cc4e485f150188cbad17fe6a9520c6f418d6870fa96e50"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6a2794a50433365ae9e8757a4122484ed4f4ad01f1234f2330af15106dde2ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "f77e1317bb235d2d3441ef5cc9201b6744d307f39426c13baa4400bf26d9da52"
    sha256 cellar: :any_skip_relocation, ventura:       "7a6e46c917bc77d83c574cfe8b3085d2a5b1144bb1b5c43dd046a0b4631b7ad6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c58e8892419888da8762986ace99d5ea2fbc0dd6d1137bae10e8a63ca0a31b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d344dc20a5de3117b6e654a1915ea3593e94e2be417946abdd72564812fb219c"
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
