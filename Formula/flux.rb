class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.190.0",
      revision: "1db34002d1d95151f74ce01626bb08de83c70acc"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58ddcded450c5b28d7bddd0ea9cd57892bacea27f10ef4c51e5fd1c7c87c12e7"
    sha256 cellar: :any,                 arm64_monterey: "1472f0759d1c7e7864ac0aeb6f2fdf7348afd920f4c304ce1c9b337981a36506"
    sha256 cellar: :any,                 arm64_big_sur:  "92fc438578d942b0eb47f52def63152e68635972869a5c99cf3eabd12e09a0fc"
    sha256 cellar: :any,                 monterey:       "bcd5ce32715f18b1ee5853d2ccb533962a004cb296811a1cd79cb952a46999fc"
    sha256 cellar: :any,                 big_sur:        "95dc4488eb88fd3296f4c4a7d2618f7c1d326c95ee00732717c7b2ff1f182870"
    sha256 cellar: :any,                 catalina:       "e83e8b4c105f73936b91af5b27f8b9e2957580eb9b78f69027545824e1672aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0aea5a7cd37e6b6b9bc73c151916973e91656f46f56d0814b80d2f59d89bd54"
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
