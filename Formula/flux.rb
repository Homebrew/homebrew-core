class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.151.1",
      revision: "f912371cbda764008b8aff30edd2b56eb2b99314"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c449474449f9d3d4b7f8762ceab04c9b0050b25732315622c808362c44115fa9"
    sha256 cellar: :any,                 arm64_big_sur:  "99dbb19a2745746dc98be105f46022ee0ff5ef0d687a4fdb8c57facecd909a4c"
    sha256 cellar: :any,                 monterey:       "995415ac2e3f8b9424950a60b20165738616f07b3126aa7e59f880662ab9099c"
    sha256 cellar: :any,                 big_sur:        "2b8ffa2653606b1a29fcde5b465a29ec5467dc567d50c45d39c56182abdc37f9"
    sha256 cellar: :any,                 catalina:       "e280dc5f79b975d99e362b003a8b2b1d23ff104aa58370ba9a2bc72e305474c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b80e3bb1155c1e30e19e56e9e8ef8d5cd971eeff55fe73b2acb339464009626a"
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
