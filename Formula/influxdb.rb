class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v2.0.6.tar.gz"
  sha256 "b8f019cfb85f7fdcdd5399dc2418cdc1ac302f99da0d031c2e307ecb62e129cd"
  license "MIT"
  revision 1
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26064c6e61a5f3f21ae929f426f24bc5074821798ddc10a236d5bbec013aea0e"
    sha256 cellar: :any_skip_relocation, big_sur:       "473f7fe873207d149a17358ccb0ae34a6db380884d569f5eefa4c9434d0df87b"
    sha256 cellar: :any_skip_relocation, catalina:      "b239400cc02c0d4b3bbd227bd813b0fee68a9608c5ff0b895a2b8789a287304e"
    sha256 cellar: :any_skip_relocation, mojave:        "6bea10702c042ecc7dffc3c9daf0370846a28d4974b981a25cf0654247ab0de1"
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
