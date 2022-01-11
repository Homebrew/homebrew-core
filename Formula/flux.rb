class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.148.0",
      revision: "5b80111fa0eecb5454156f88a1e4463d55c47fdb"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afd33cda7992a55aee59daeb94d998771b1e10da117c0a8441ec72a19e1be93c"
    sha256 cellar: :any,                 arm64_big_sur:  "8dedbad43187c3db310dd78af2c7c4d2f5d871b97a30a495bc40282c2a5bc771"
    sha256 cellar: :any,                 monterey:       "984aa3913947eaed5015f2d2f8920192898ce991d6dbb1bc0c8918740d905b46"
    sha256 cellar: :any,                 big_sur:        "dc7d13252d5a790f5b08bdb1e3ad8de3599a616d2a71fafbaf2434ab81d9c847"
    sha256 cellar: :any,                 catalina:       "92e12f547c405686d07d04874850a6e75cb518d85cda2204cee6f14d52426625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca2e79014846e971dd653fa68e143dad645aab7961d04a31f781fa74d54ad19"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/v0.2.10.tar.gz"
    sha256 "460b389eeccf5e2e073ba3c77c04e19181e25e67e55891c75d6a46de811f60ce"
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
    assert_equal "8\n", shell_output(bin/"flux execute \"5.0 + 3.0\"")
  end
end
