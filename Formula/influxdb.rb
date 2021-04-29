class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v2.0.6.tar.gz"
  sha256 "b8f019cfb85f7fdcdd5399dc2418cdc1ac302f99da0d031c2e307ecb62e129cd"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5cc2b66515ba05702f83ff7fece0391ffbc9f48b03f5e225fcc5e06e73562561"
    sha256 cellar: :any_skip_relocation, big_sur:       "6754ca1e43f64c1f39e2be55c8d090db5fc2790098220512bc1935891ad0fcd7"
    sha256 cellar: :any_skip_relocation, catalina:      "a2daf3a845cc5b86b31c735d5bc8c16b56e31e881e3413936f18014daa2c9a92"
    sha256 cellar: :any_skip_relocation, mojave:        "ca4e4651d17d3f42c344a280ba82d418fb77d0702235033b651b75b1b113342a"
  end

  depends_on "bazaar" => :build
  depends_on "go" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "yarn" => :build
  depends_on "protobuf"

  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/0.2.1.tar.gz"
    sha256 "a31955bae060799b482d36ed522e76d55e1002d879d38371ed43d254b51f59d5"
  end

  def install
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"influx", "./cmd/influx"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"influxd", "./cmd/influxd"
  end

  test do
    assert_match "assets-path:", shell_output("#{bin}/influxd print-config")
  end
end
