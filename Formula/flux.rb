class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.155.0",
      revision: "8089f4491c0a13ff99e538a6ad8636e1481d53dd"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "83bba760cc85fa70878e7e25203f33465c633525b9c584a86099030332eef1e5"
    sha256 cellar: :any,                 arm64_big_sur:  "06777ebb17298dd64c7aed1de40bc2e07989cfcbd953337ac926e4fe2107b2d7"
    sha256 cellar: :any,                 monterey:       "7953740a15e603f7a2c01424f910b02c7cf7ac3d0b136cbceff5652908d75c7f"
    sha256 cellar: :any,                 big_sur:        "ea191b7b2f623da5d242fa155c0708abdcab5467bca46f47fbae7e12fcdcb665"
    sha256 cellar: :any,                 catalina:       "8e5f53edba84354b4410f104e0c5a8b660704832ca0bfcd1d864070c6b42303c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fc654622ca22a53c7a16b31ae193575978cd3e83c984cd9817ab447c5a140db"
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
