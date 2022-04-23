class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.164.1",
      revision: "e45353dd067b59bc4e46dd315de1221e1b6da36d"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3f2c73f4b8b904aaad6e43153805dc0f4967b823283fb79e5f6ffd18908f992"
    sha256 cellar: :any,                 arm64_big_sur:  "2429923f383e34794f1279c262e5a13adea4ddbe41ac32de3f9748296871d886"
    sha256 cellar: :any,                 monterey:       "4d12eb6c8fcdc824f14c53689506cf164ca747d9188656b66068ad1eb37d22e4"
    sha256 cellar: :any,                 big_sur:        "8cf072d7aaae06bbd09a65ca0f508e9b78f5ade1c8f12f3f67a4cdadd0c49068"
    sha256 cellar: :any,                 catalina:       "71b679e169817ed72ecbeec207386d4d7c8f3eaed016e16d3c26df4869f90a11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad963dd12e1e93db0f9bb5b6a7c271dd8f4296b81168724d7f1e03f5be889d59"
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
