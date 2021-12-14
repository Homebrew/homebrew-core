class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.146.0",
      revision: "5284a7f38f4030c1e3179d203953d153a61e5d11"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b244c94e118cf26037e9b566a0a506de59514adf62d81a7e41d2a2f206a89a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f611b5775ca03cc938beb2de6c71a238618312ce9c1af30641824f94a3d659a9"
    sha256 cellar: :any,                 monterey:       "72af810432e3a2d87ceb021cd8b45bdf640680abe3fc0dd39225dbea64e4a306"
    sha256 cellar: :any,                 big_sur:        "81f3e737d8aef9dd49407b4672a069b424e81d50083ff0feacf1c2d0bc621c08"
    sha256 cellar: :any,                 catalina:       "6f3de563b9222f98bfa5725e639f76c823d222af94fe6ccb8e4e25362c638ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4c32a433ec79f1416ee14524c4a3c6c10718cbfbb24a408b4c1fc65f3c838c"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.10.tar.gz"
    sha256 "460b389eeccf5e2e073ba3c77c04e19181e25e67e55891c75d6a46de811f60ce"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args(output: buildpath/"bootstrap/pkg-config")
    end
    ENV.prepend_path "PATH", buildpath/"bootstrap"

    system "make", "build"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flux"
    include.install "libflux/include/influxdata"
    lib.install Dir["libflux/target/*/release/libflux.{dylib,a,so}"]
  end

  test do
    assert_equal "8\n", shell_output(bin/"flux execute \"5.0 + 3.0\"")
  end
end
