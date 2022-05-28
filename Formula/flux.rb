class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.168.0",
      revision: "773519e3720a5f44e0352d97474de12f03ba0f5b"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08ee518d04e7c9b60e343df76147b3ebc359a3c5bfda73afd5d8860f9b4b0fdf"
    sha256 cellar: :any,                 arm64_big_sur:  "8fbaed0abeba6204dd9fa16cd29084624d8ae48d3719418743eb7f5f737e69ea"
    sha256 cellar: :any,                 monterey:       "29981373cd0c57d16231c2fff65cbef6f7a7fbed92630a74aa9098c036744d92"
    sha256 cellar: :any,                 big_sur:        "9e2b91a7148f9d41e8819b5b0392f68d00fa5f2d5ee94209c436ce2596ee76c1"
    sha256 cellar: :any,                 catalina:       "21152a5b272a1dd25245fafa3cf7e35d1f35124b1a0f8d6ae951194656dca464"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f9a74b7bf59ce5d63aaa67ed04197fcf0b35a0373fd976edd9caad229a3a20"
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
