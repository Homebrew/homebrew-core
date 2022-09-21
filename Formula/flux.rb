class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.184.0",
      revision: "41ef75cd452eb2fb242e1db82b528dcda53302d4"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "156c9778caadb9503107e3c899ea280799178762c06999362049f435c518cedf"
    sha256 cellar: :any,                 arm64_big_sur:  "5d258591a57d285e62696b31c6344e8df65f34e487597b9aff1ba60c33cfcc58"
    sha256 cellar: :any,                 monterey:       "d401dcb98170a718c04d91ec695bdc5a4ba174efd41d9bebcbcef71978741f45"
    sha256 cellar: :any,                 big_sur:        "5266f8f1c85af932ba0b8a25c94597597f2d0acf36d3c18c8b5c7634a995626e"
    sha256 cellar: :any,                 catalina:       "5c2043469a4d8a6fa280583a253dd6642529148a59cc5c4bd21383954ebf3e03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43af2f6d8799eb5ae0fa3c00eb02838f597308ca1227fbe8f4834a4f08fe989e"
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
