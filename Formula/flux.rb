class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.191.0",
      revision: "b9d6eb68390c18de9f4e33f176337656babfc8cf"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0cddab0ca727689538c2bc2b4e4ddf89a7d7969dbca45f1651323bf0b5148756"
    sha256 cellar: :any,                 arm64_monterey: "67a6871ed6d551fcce1aff292e32d81eb77366de330b23f18ae113b374c04c62"
    sha256 cellar: :any,                 arm64_big_sur:  "41a55889deb832edf1aa16597b41f5d661d6d466776462d5a76e7e0dce624b6a"
    sha256 cellar: :any,                 ventura:        "dd1671d27a302bb6bf76209dd6f82f185dfd90409217e70ee60fd9b784efe4e8"
    sha256 cellar: :any,                 monterey:       "c0fdf7c2d0d7983faf4746132eab29ce4417e4825a88b5b2417a50ddb8d414ac"
    sha256 cellar: :any,                 big_sur:        "b9bf48060d62101dd49a45ca78d10c02e4fbcd066e9c1a0163da293f31fbdfbb"
    sha256 cellar: :any,                 catalina:       "d4f054e77c15e141fed3c1c8f9ed31b6f92dce18f76f6f3bb0df30fb1a2033fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2907ae7ca3ec9d49abb5b7e41ecb2cbb647845c3a748471b389bc2f7ef89e43"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
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
    (testpath/"test.flux").write <<~EOS
      1.0   + 2.0
    EOS
    system bin/"flux", "fmt", "--write-result-to-source", testpath/"test.flux"
    assert_equal "1.0 + 2.0\n", (testpath/"test.flux").read
  end
end
