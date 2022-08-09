class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.178.0",
      revision: "d0ff2cfbd20474784159cc90afa8ba577c2abd5a"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b9d98453733175a5280e82a7cdcfac5a1c49febd2778c47091e90c854923bc80"
    sha256 cellar: :any,                 arm64_big_sur:  "281d6d39f2ab8e2568a5dce0c8dae80a7ae2dbf2e336a20741a616c3092ceffd"
    sha256 cellar: :any,                 monterey:       "b0a26c3fe46fdec91f7da9dd7a5f9f9e3335a2d98ce32b987a44e033db5ddf5d"
    sha256 cellar: :any,                 big_sur:        "7dceb056844a52ed389e753ffe0022856260ca7b16ed5cff972e1e6d1a192386"
    sha256 cellar: :any,                 catalina:       "3fca7e84c81f3e60bca691fc46a4d63ff08dd5d90a239f08e8620b0bb00a7e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00bf43734e45a34c5877cae664ac78f7d68d9ca4fe5acb7e0fad02cd08ffea47"
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
