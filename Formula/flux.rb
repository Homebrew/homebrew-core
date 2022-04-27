class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.165.0",
      revision: "ead736ee677d08df1df73a4aba097f28ae126022"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d15ec35fd6a70e70107dc4d9af85a8ca718ccb01632234766f31b255169d1d83"
    sha256 cellar: :any,                 arm64_big_sur:  "c4abdf45d73dd663ef8cd5a971e6d675940a0ed7d24fce304685dc294f30a2dc"
    sha256 cellar: :any,                 monterey:       "8941bdf99976844b22a1e813ca5e947bf247f0f0157bdb3807c8966837e75fa8"
    sha256 cellar: :any,                 big_sur:        "2f5c7e23c0cf8c4f07f32428339ec9e86a4a2476de63ecd4a808ce2cc2a3d4c3"
    sha256 cellar: :any,                 catalina:       "98d460ad725ce7d7d054b97a7a88022c5da12b692d433a5bf8692dcd13185286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f3154b7cd7076e432cf05bcf3637040545620a23536792b16f13c41fd80bda8"
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
