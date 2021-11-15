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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c16f38a7942207df77e66eedb97ce568b728619cd420521cdfc55d9c3dd4abf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cab3ad722b4cee4db9869f4de26e312cb58942af958cf7f0173b86bb73284f82"
    sha256 cellar: :any,                 monterey:       "474cefa87838338c0b5e4a16ce539afc6880c38874a9c11d32d309886bdfb014"
    sha256 cellar: :any,                 big_sur:        "0ca5d9b5ec459d3048264e456943909c8df05fd1a156bf304e2d8ff275e8567f"
    sha256 cellar: :any,                 catalina:       "d2f0b1cf0ae70949964d97d0615bd2ad9fc7085c4bca7a48dc60ad7f67e3ee77"
    sha256 cellar: :any,                 mojave:         "28923462a1770082cf1db480cbb9ac81eaf26520d1c53064dc395052232b3cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "619808da2cb5bd3c0282f5142f1e9c7359265f890ad2023a0b3e223533fbad04"
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
