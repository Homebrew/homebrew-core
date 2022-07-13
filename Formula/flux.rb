class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.174.1",
      revision: "53c90d5abbffa5c2c91c5e64e262d083ec4dff1a"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0090f763d2dd62dadf5a7f7aedd11e983e2757f1c1ffeb797b649428a6597c80"
    sha256 cellar: :any,                 arm64_big_sur:  "94a99199564eec7b9b46bec6e3635d6468713880819b95e7876eef23aea38bf8"
    sha256 cellar: :any,                 monterey:       "462e243c8d60a5a040f42784043466278ca891a954bdc2991f960b6d1f9cf421"
    sha256 cellar: :any,                 big_sur:        "5369b6bedabe5b8f531c6d7e4703a2fcd6952ce3bd8f42765d6c832adc7460d8"
    sha256 cellar: :any,                 catalina:       "c4e95c4b6a726f41a32d1efab612c89738839e782a2d59f670a468aa609b7083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ba99f1a0d3743f34b4179c1eab2ba866269dc8c7a865b44671d3d3ff1b02ee0"
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
