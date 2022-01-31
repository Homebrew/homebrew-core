class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.152.0",
      revision: "7a01fff54085c97bf3099f929846edff63f05ed2"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "19e11d891383cca8079452ce1f2d800a847ac7611a2c3d5c015d698ea401d9ef"
    sha256 cellar: :any,                 arm64_big_sur:  "690a5a69d9485dda049f19422c561c9cc11d4f5a6276c764d0da6f2dc15f4730"
    sha256 cellar: :any,                 monterey:       "e910132503e12441ef9dddbff71a56cda8e057032eee7abed4c76e00b1e82933"
    sha256 cellar: :any,                 big_sur:        "a7c627e70ed06cbe4666cfe9e3e0316a636e8eb5c151222128a87cf6ee4029de"
    sha256 cellar: :any,                 catalina:       "ff66b95c9315fac27076af2aca427752b7ef5eafb01ae5a97ac6c872d169ebb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "101856c480807822fc2de34f44d1e56abdd0478783754ebb1abb8e0d33087672"
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
