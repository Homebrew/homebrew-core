class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.177.1",
      revision: "fefa5528cd6a348e2a7e83a9fc55ef522cc8ee4c"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3dfa940e5df414e59cc930fb4ffe4a5acf8e5e6b5bb5102a7c78c495e5e43c26"
    sha256 cellar: :any,                 arm64_big_sur:  "e5a8a4bc9f61a540803b4d0feaa69f5a3c995e0e2cd44a2dea2da35b4847a400"
    sha256 cellar: :any,                 monterey:       "02a25cad66d94719e83f087bda4477b968364f8469b72954ed8e33a3a3ee15c7"
    sha256 cellar: :any,                 big_sur:        "635782aff472a165b75d8865f12f279dd682c83f124462d53ed061840dba4fba"
    sha256 cellar: :any,                 catalina:       "1b9494a0306fb38086c208aeb409f88e33a921ffe19961b564acbf570738dc0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2608612309c156b4b39648c676308f7eb717cc5d69eae43b37abf06ecd46e3e2"
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
