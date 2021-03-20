class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v2.0.4.tar.gz"
  sha256 "73ebee977b8f2235eea5d280d7d9fcff8e29cf1e61c5c370ae9939d92f085c6d"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a14b0bb22f27de27b072abf29ab014cc9723e2871904700471f78e6d9f6f030"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ed45e33953ab84c6f5b8a862da62135164a10926c81186ba5587a7f65a0041"
    sha256 cellar: :any_skip_relocation, catalina:      "6d88fe5e33124a220eb70d8e140fdb213b13d465560ef04a8bc3a9b992d1dd94"
    sha256 cellar: :any_skip_relocation, mojave:        "ad332849b3ab8d6a07e58a06a2164ccc207652797f55e396f3845081a006a121"
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

    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"influx", "./cmd/influx"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-o", bin/"influxd", "./cmd/influxd"
  end

  test do
    assert_match "assets-path:", shell_output("#{bin}/influxd print-config")
  end
end
