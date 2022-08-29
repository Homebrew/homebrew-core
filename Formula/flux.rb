class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.181.0",
      revision: "d6a97eff2123bf75323bad1319ff10751177c445"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2dc4e213e94efa5a15a2217ac03a769ec519f70f4656b44d9d1d3d25209d8df0"
    sha256 cellar: :any,                 arm64_big_sur:  "b29f59fc794b8b2c6e09dc0c8240eed91bd68eb765bc86795b1d4242d1d73bfe"
    sha256 cellar: :any,                 monterey:       "6e87cc931df2f8f97a3acc0eac793a5bc435c9d38d7441d73381f9cde5e02b8e"
    sha256 cellar: :any,                 big_sur:        "6386cbe02c953a7857bd6bde236414b95ba439c591b6a2caad3fbd7023ce98b5"
    sha256 cellar: :any,                 catalina:       "6b4137ba4f0e28964e1133975723aaf35b62817cdf2220292de9968b87847d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8e896cf173f73024cda26b609221ebda521de6692bb8b3166e8cd45fa97009d"
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
