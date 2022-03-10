class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.158.0",
      revision: "93bfbc9bf88270882b7b305990fb944726435212"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "22f9ddb770431c863c10585bd8e02dd1a00369cf7f7953c4544ac0352d841ffc"
    sha256 cellar: :any,                 arm64_big_sur:  "fb090ba75039f3574c981ec8aaa4c47645195d19e59583d800f8a3767352ef79"
    sha256 cellar: :any,                 monterey:       "ebfbd7f683639afb72d226413f80b8a7449f202d1a99402eb673682ebdf166c9"
    sha256 cellar: :any,                 big_sur:        "5a728c8996f2c7157be919b16721373bea7c2009f0472b36eb56d6ae4f0b2726"
    sha256 cellar: :any,                 catalina:       "bff99a719698bbb340f0d143b880648bcdbc3d0c6c5d6b12e347f896e6706c30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eef166f25cbb698bba9abfc04bb8bac7da6df78c0fdc32ed9a3c393d5523b31"
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
