class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.182.0",
      revision: "80c7979532eefb8f4f2a130f22c274724cb5c943"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4830ccc5c5e9dce89328a456b12f88149a623f6e6311abb8ec8c167efee25dc6"
    sha256 cellar: :any,                 arm64_big_sur:  "0e3c7d50514bacd65c515de2d0a2187edebc4998bf56ccd89fda35be91c430d2"
    sha256 cellar: :any,                 monterey:       "bfc639d71851a9e3f54236b8af95aa76ad0597ca73c7b6db2cc4309b347dd72b"
    sha256 cellar: :any,                 big_sur:        "36030b5417a47151f34e49ca560a4c83b25804483a3c0bb61e62d330229c7444"
    sha256 cellar: :any,                 catalina:       "1dc3a6cf82bcdd7a25c07cdc7deb7427d7312c5c44a9bc4377b5c8d5a09bac12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5130a9971e9b1c0b2a072c5b7428a0b1079d3c42eafa2d49ae0b55a905f39307"
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
