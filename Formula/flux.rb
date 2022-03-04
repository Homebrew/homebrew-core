class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.157.1",
      revision: "59e6485e13e6d3bd27262abd27074c06ee80bf3e"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c2858a923c4bb2188b60b3bec673898d31ba79e12f17af6768d753a95022d52e"
    sha256 cellar: :any,                 arm64_big_sur:  "28b3a731bb91c41412b9daaef25d656a567ea911d339bfab49e22f29b2a07df9"
    sha256 cellar: :any,                 monterey:       "e44175776d71db0a151a246fcc35ebb40eb75032d0e191386fd21f831f303c34"
    sha256 cellar: :any,                 big_sur:        "c36a5bd86adb604a966c80c06306db4af93e21f1e9cf370fac0340dbe4e91451"
    sha256 cellar: :any,                 catalina:       "48dfb32c0f5a0db0a310f4fbbd22611dee13660b71f66dcfd951a3da16c7c791"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14a7485f51934b643f08aa8b90c2884095b447686acf4a69a3a0e197b2c555f1"
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
