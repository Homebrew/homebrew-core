class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v2.0.5.tar.gz"
  sha256 "eed308b586cfa78b5ac05ed5ac4fee05efcf9351bae3ab2909921fcb0764bc87"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14dc698d715665247ef547cc346583e430f49f4e3db08cbfdcd212e33cce98fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "3773ee758a006c963e19a05ef6c3c2f643a91e67a08fb4e3b66ff2b2ef331226"
    sha256 cellar: :any_skip_relocation, catalina:      "b771d55808f9486f6a39fab1435fcbf92741b3290bc8aebe4b40984b9164f741"
    sha256 cellar: :any_skip_relocation, mojave:        "d18787b5d6650636ce16440dd49d80703b1d7e29f5379e513788448f1466650a"
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
