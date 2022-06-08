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
    sha256 cellar: :any,                 arm64_monterey: "82b24f7535807c0ed0aca1c6c22bf4767473c8f98fbcffd2f18a55e1a460dacf"
    sha256 cellar: :any,                 arm64_big_sur:  "babe905dad6d18ea88b3be4432169cc5fcd6d63a3556c3d6562a2fba3095406c"
    sha256 cellar: :any,                 monterey:       "91ffd7521dd54d1aa4daae430e60281f7cd795b7c85e4d32e6c9248da5b00be6"
    sha256 cellar: :any,                 big_sur:        "03b441ad96f83fcab77decc167bfb7de3ffa2c755ca8f80f49e943136682d874"
    sha256 cellar: :any,                 catalina:       "d8487182a68c60780d47a23738a8563abdd3d372cb3c56259cbd317f559c6962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "048d7c9082f85c0331c17263cb256b203736ad820931fbd1984eeb422c856db0"
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
