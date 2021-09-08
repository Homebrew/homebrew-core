class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.128.0",
      revision: "1883bac5ff6ec06b4004a70f5823d42828b82bc3"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96ab36c5e4a07a90820e0de57ba61f79f60b723301c1b3c755bbea8dc2657fbc"
    sha256 cellar: :any,                 big_sur:       "ab9979bdfe3a6a9840249b67dfd9b371b2972b5d757f723bfff5d98a689c0cf1"
    sha256 cellar: :any,                 catalina:      "df4718543f250b6c78859f90e35f66c9a157f9ed0f142061c3b0414f82d2c672"
    sha256 cellar: :any,                 mojave:        "01a1bf060d24149fd72c9b0e5e499f2e8012f604545a44b4467f99c8d849b055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bb7e56d5348a4c0c1eb7f3d484872222aa3f7648121450b9aa977f11f4ddf52"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.8.tar.gz"
    sha256 "9d3f3bbcac7c787f6e8846e70172d06bd4d7394b4bcd0b8572fe2f1d03edc11b"
  end

  def install
    # Set up the influxdata pkg-config wrapper to enable just-in-time compilation & linking
    # of the Rust components in the server.
    resource("pkg-config-wrapper").stage do
      system "go", "build", *std_go_args, "-o", buildpath/"bootstrap/pkg-config"
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
