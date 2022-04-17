class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.164.0",
      revision: "b48a01b38cbeee176a90466439db74f370b0dbbb"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fecfe2aea4d854ee0f1a889565428c51b7a2d0d24b659477a4182492b14ebba9"
    sha256 cellar: :any,                 arm64_big_sur:  "67beec443309b050edb1bd93d3ea48cd0603ae2d491796f30bfc40fc71423459"
    sha256 cellar: :any,                 monterey:       "360880d786483ace4fddfaf6f8a7f0df91f0d2a4882ac5b24b9f5d07fc3a378e"
    sha256 cellar: :any,                 big_sur:        "e2d88fe85695c9adb53b3ee451395168b3a82150f5c258a09416818b39f663a9"
    sha256 cellar: :any,                 catalina:       "5092516cfef6d83db6b9caf0e800f05468caca542d6ef349406efc0d0507ba15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1b15e527de07ad41c12c70e95a68aa18e5bdc0654e885c2af517ac5bd619841"
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
