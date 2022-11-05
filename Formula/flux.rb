class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.189.0",
      revision: "6cfedfb39bc0d70849844883a5d2929cc057f264"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f49c73f0146b78bbe895948f43cc122b6ca84429586e63a0aea9a79724fc9bde"
    sha256 cellar: :any,                 arm64_big_sur:  "b2f5f87b4c0d377c5d7304b4613f1b732fd146fe19065035bd7af99de96e0a43"
    sha256 cellar: :any,                 monterey:       "4299e4252df10aa9ea1c7e0990dda94610439652a0d362181b2944c2627678f8"
    sha256 cellar: :any,                 big_sur:        "56814b34831c54c41f19fba326673c1edc3a097b88c8114d3679c027bb67976f"
    sha256 cellar: :any,                 catalina:       "cdb0925494398d8c1c21a6e84e48b037e87c421b5e2d5a7c451c17a89de4a97c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "938a9ce6c806153175da53071cd6e3a662fd07d8483403efeffef82b852c0ca5"
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
