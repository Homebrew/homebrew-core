class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.153.0",
      revision: "f4b59734c0e21d475a08526534b1cd782a27f10f"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "939532f757ab1c424ee6fcf65b3c18d07106e2f8b58c944a09fc8bd739765ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "3e546a6fdd4103641d629842d082c9ea6a31e13c665b68c124884e1bdf4ea80c"
    sha256 cellar: :any,                 monterey:       "8c1f8a270d189e50bef7aa60c4afdf1e726091d63320a4293b17fe881a356c56"
    sha256 cellar: :any,                 big_sur:        "a9c292ed5326a0458adb1919db0e07026f8d016d7caac6010c1a16be60518b4e"
    sha256 cellar: :any,                 catalina:       "f582af8e21393f3d2fe9875ad8c07e54c49ff532f725d8f4876d9f9b013d2f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e53b01a5396cc1a9f3899be03907a79c9b2389ea1cbb0ac5c322776c806737a"
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
