class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.174.0",
      revision: "5230eea64126b586668379b071da37ca265d3a28"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc607ac1ed53f5b355a91abea78e50e7880b404c908c703a80cf62e7e4411f5d"
    sha256 cellar: :any,                 arm64_big_sur:  "eba70cd04694e1c6ec9f7b48a349751cb4a877e9cf4642add604447e23e1cdc7"
    sha256 cellar: :any,                 monterey:       "e84202a2673c0db4f0f2ecec7913aa38934ad9aa05194d4a6ae0dfc408cb8950"
    sha256 cellar: :any,                 big_sur:        "474eaac6d13041364c7917edbd0862df483c1a1ce15a1db3f3dd7b30902875bd"
    sha256 cellar: :any,                 catalina:       "be3d8609d5943d4d2e74c59a3df0c9f6d3fdc643211b065219615e94b1905f82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c18941f7e97f1cef2ff21b14186a10f77428b3a89ff6c0769b85a5db00215a"
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
