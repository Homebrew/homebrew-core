class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.167.0",
      revision: "86757029750fd2c68c6d10a643590cd774a5acdf"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4fc9021f80e2860c27bfd98c63458608a2e39c0523659133976f667ba554dae0"
    sha256 cellar: :any,                 arm64_big_sur:  "3dcebfdec90a5fcc6083f0ec519fefc76537e8f44f60f934b595f5611876d9a1"
    sha256 cellar: :any,                 monterey:       "e4088404de38e3fc49dc18cbdde464e1fa2437b021fe352b5bdd22edd324b39d"
    sha256 cellar: :any,                 big_sur:        "da4660570b6e6032667e262910032d19fadb930457216d3312271ed48441fd7e"
    sha256 cellar: :any,                 catalina:       "91926b1b284a9ed2e75386c130e4330556b7f122b1ea6066dc977cd38f16144d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4431338b2a46fce89fa2c195c9dea6abb0a1e6ebfb4c8cc66c26bf2d7dba2bc"
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
