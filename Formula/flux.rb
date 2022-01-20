class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.150.1",
      revision: "7da5c2d32884577f449ca6629e33d8ec720918bd"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44b504f0aa654248e1e9730a6211dcff24ad5021b1135b334cb97e678cac5a52"
    sha256 cellar: :any,                 arm64_big_sur:  "708b41d45c281bde4578b4b07d331ba23160df38b5d81322218becd92ca81c7f"
    sha256 cellar: :any,                 monterey:       "fc5c078b8444af4353fdbe8c99d56fe2c9caf5f3e3a3c33f530693eb086cc972"
    sha256 cellar: :any,                 big_sur:        "639114648895c56b50f326e048b6794b16cc57c35bdd070f79a9b2be2923e833"
    sha256 cellar: :any,                 catalina:       "73020be911539187e2f84c167b38c09883cf1a9d2b7f00723d66700d705db400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50d1bfae5c53b704d33c38860246b5d8d94041a8fa0ab0d9ea56e64d7eec5f37"
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
