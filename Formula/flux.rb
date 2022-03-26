class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.161.0",
      revision: "7213ec1a15afa12dc0f2fa402cb0018187e602d4"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c4125514f5dd1f21dcb1e9410dd68706c7e2218e85d1892ad59fee5ea8a6cdad"
    sha256 cellar: :any,                 arm64_big_sur:  "1b3f2a71f35f6dad86c37da4de214d69157d90b370bc41461699d649a2c090f6"
    sha256 cellar: :any,                 monterey:       "9c75987eab088113f41c9d00f25ee96f13020b33cfc665eae9cbb198899e0dcb"
    sha256 cellar: :any,                 big_sur:        "9db77689f0330243a63b4407d69e560ee6d09ba307ea462a35d1ff831e8557b5"
    sha256 cellar: :any,                 catalina:       "2180d1606dc33733ee2053086749f739fc74a90230708eb14a4c8890073c3d3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8495fec1e3a53964b900a6d1e7d28fa9b4288d8adaaf9e13f9818d2638f202c8"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.11.tar.gz"
    sha256 "52b22c151163dfb051fd44e7d103fc4cde6ae8ff852ffc13adeef19d21c36682"
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
