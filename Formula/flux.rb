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
    sha256 cellar: :any,                 arm64_monterey: "44790431c9e4cdf02c9360e34c19cd7f10e3cc39d7a5a305cff4965e58427d31"
    sha256 cellar: :any,                 arm64_big_sur:  "c3479417b9d6f07c9b42c227eaacb8c8dd9702cd069d8427213853048581263a"
    sha256 cellar: :any,                 monterey:       "bf5727a42200dbfb0ea340154ca126f551aa91a0b143e10cd4db8be687c0eb81"
    sha256 cellar: :any,                 big_sur:        "91df93a7bc9592e733e2a70b43dc17df67d1caece6ff9bcc9a6fb3fcaab0c9c1"
    sha256 cellar: :any,                 catalina:       "f3cca3f9d830155d6a10584ceb72caf6db8b551c9866dad4c33470c1bc97ec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c61c9b99c2475d48a451649e6abfafd490927d768f099b43f04b43dc2c6f5cd9"
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
