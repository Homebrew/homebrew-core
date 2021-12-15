class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.147.0",
      revision: "8c648bac49c8d9f74cec6ca86995b1c31b387e51"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "085a71eb15cc10532dbb8865dc0ea8038c063608e1fcbebb9c1b6871b43059e2"
    sha256 cellar: :any,                 arm64_big_sur:  "12fedc7ab2a0c46c42e9114f1080b272c31f3a569d2fc4622629947674e30f35"
    sha256 cellar: :any,                 monterey:       "f2426f8df9f18c7ef53b93415a2c9d28693d3c74694fd54c2a6ed45f8dd66544"
    sha256 cellar: :any,                 big_sur:        "b01ed72b8b791d53719c5affc29d4869e4126fb4733a81dec00b0054591fbce3"
    sha256 cellar: :any,                 catalina:       "f61df5ec3f5c733f32dd8e55daec6aca8fc5cf1fcc5aa5aaf9a18fa4e8463c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "044cd9a0f1488ad0dcc407aad7f58d99f7c55ae47668380f30e725e9410a9688"
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
