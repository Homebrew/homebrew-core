class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.183.0",
      revision: "e0cfb6641e20c78c9c0c4a45f681fcc5bc0ef683"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2ede6c7230e23ac1cc134a1719a1590b74a766f900170a1606523fa9fefa1078"
    sha256 cellar: :any,                 arm64_big_sur:  "f0296ae500767774892d8b074a5b26d6568dacb81f507983f39a8ea3f2630cf7"
    sha256 cellar: :any,                 monterey:       "ed459810f3e1df21112c40e50a197dca07fb8444a8b249a0c1bc5d22ec0c3ffd"
    sha256 cellar: :any,                 big_sur:        "5a45f699ce7aed43c63fb11a00a87bd6f1fe36b8588b3d4a45b5d5e3ef577ae9"
    sha256 cellar: :any,                 catalina:       "628731406d60db5b812cc01210a6319f619d2c78e32bf367954760dcd6e69fd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e450a9c9a3da865333f0c5c403d21189fa75fac64472692d843c19de4b566d68"
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
