class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.180.0",
      revision: "32fe18dbcdc6ea4a30cf467231c84cdbf8d1bd54"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3122d0496b2ab21d600f7e12475b81d6002731abe9c3ff53e2e547ff21bdac04"
    sha256 cellar: :any,                 arm64_big_sur:  "b304a101234fbecd6e393b9352867f9a2f4ca69cf4e8c0777b1b6516ac1179ae"
    sha256 cellar: :any,                 monterey:       "130a0ce3942cd9bb1f48f3f566d22281e0b98917628aafeead219bb8a5288d37"
    sha256 cellar: :any,                 big_sur:        "6d70dca412ae00868127792152ab27bde2d336f1719e88f24d71becb8d70af5d"
    sha256 cellar: :any,                 catalina:       "00a63f500d8f0d94e4db479faaccc3b7e9685ccbf6a2dc0e4c4120b3a87ab519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59af69a59494c8bd9958e42fd7c6df73b7254525ecad34c4dec5ed1666bc03a0"
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
