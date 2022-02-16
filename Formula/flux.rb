class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.155.1",
      revision: "6e61eba4fee1f2b30db2912eb8500b95951e9b93"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea83870667cf3e2502679589beaa3ef0cb481f56bec36a917a8ee10e80f6cf19"
    sha256 cellar: :any,                 arm64_big_sur:  "579b02da65d1a1005a0e983c13ff890fde009fa66146d01a7034afa0e1a5064c"
    sha256 cellar: :any,                 monterey:       "2035ac57049ae932e5c544462be20e0f4ee5f4f125b7576ca171999e8d87abd1"
    sha256 cellar: :any,                 big_sur:        "909db68708f4182002c8d040ea93b9630ffb436d771a745d5b8ecb886a856ab5"
    sha256 cellar: :any,                 catalina:       "edbfa4cc6467685de6c03b0615aa20b330226765e682a8cec9af64e0956a9c06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2f06203bc42ede552bc157d9893bcfa56e9bf24f1fe06b57bf1cbe8ce771e5c"
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
