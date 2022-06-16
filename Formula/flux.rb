class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.171.0",
      revision: "f8817e020abb631e7e4216684bb342246d829deb"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a478c6d26964c2b02acdcdb2be2fbd48e8ee17e70830c5f18910098a5a7a33de"
    sha256 cellar: :any,                 arm64_big_sur:  "52df6df9cf45eec92159f1767730af8eed93a94229b76e137baa8cf696b5695c"
    sha256 cellar: :any,                 monterey:       "92f3e475744ab919ae0e9159fe4a03fa04093ab39880e6877e64f970430f0ecc"
    sha256 cellar: :any,                 big_sur:        "5932f2cafb2e21d32b344a68c38823a1fdd21e413a0eeb0ae1e1b95ddfa5604d"
    sha256 cellar: :any,                 catalina:       "a9f9da959ddd1d287f47465fbe7ec88d3a1cf0bb3a5af5985c0ec4547ea4bcf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00827dafb6cf135da4411e60b377e42bd28494b03f3c3e120763414f29a5294a"
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
