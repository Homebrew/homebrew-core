class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.170.1",
      revision: "878a9f1a60837db0e28c473ea0e12a1f730650ed"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ec82f5853853937df71f305824bf045bccfbc3b2a3f21013bb08d0e415568ad7"
    sha256 cellar: :any,                 arm64_big_sur:  "14e0de0762c1d72ea63269c35e367b9de237521da12374b1a542dc133a7da0a6"
    sha256 cellar: :any,                 monterey:       "c81bf2bdb3dc0a786d2bd6cf834027ae7e218df918329e3061ee1ebc7c4bf9a0"
    sha256 cellar: :any,                 big_sur:        "15a05c0cf3d11881c3f6c9eac8da26fd809306b10d3f8b2d03464dbd4130c521"
    sha256 cellar: :any,                 catalina:       "3f56430cbbfc6c41557ace4db040530d27fe19723fa6b8b07defa6f77d538e05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4124541d69ed7c85830fd762f45bc42dc2805b13340c5ff9767588270236fdb9"
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
