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
    sha256 cellar: :any,                 arm64_monterey: "1098f31201e75f299c328d0a3a6638940e8507a2953686231d214a3b3e913699"
    sha256 cellar: :any,                 arm64_big_sur:  "bc27f13a7214f92850098f6f459611ad8c5b8fa4f38e725fb1a6d674c1af8691"
    sha256 cellar: :any,                 monterey:       "f5b41214158b2385c2696331c73a337d92ed591713db7254fc264c987d3f2676"
    sha256 cellar: :any,                 big_sur:        "7598db44cb399cb81859f62da2680acf4a1c15405d3c69f52c42c4ad1302c9d1"
    sha256 cellar: :any,                 catalina:       "f9be3b9292b22f03e392af0f9ab24bb1c265bfa2c0e168cd3e9d9b275eadcb8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56b05698fb412afcac7ecb4ea9bc044951bdb444f7d3540e5568a1b7844ef863"
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
