class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.170.0",
      revision: "167cfbf4677fd7e9a5de1913254e2b3436aedc81"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ba570b21a3e2df83c655d1fad5087c9397cc9494e14637ce930bb74da7ac6344"
    sha256 cellar: :any,                 arm64_big_sur:  "a462daf85b4e9754eaa886a4ae579551d5c6ec9bcb5abf40e0c8d3aca638faac"
    sha256 cellar: :any,                 monterey:       "3cce242e0aa9789d70bd2bf1589f53afc6c3de782dd5cca586df62422334489d"
    sha256 cellar: :any,                 big_sur:        "d0ed7fc15c46e361e7d3b4fc4b4332bda07762edc005aef0c12553b53d3d4943"
    sha256 cellar: :any,                 catalina:       "98661547c8e65b1c43bc2cf985e16085d2b1fd158b0b16b306d4c3a4aca41330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680ac7a2b00720d806698a37953829b5acbd1e7528a0dd1c888a9a6c258e159c"
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
