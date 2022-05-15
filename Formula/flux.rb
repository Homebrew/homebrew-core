class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.166.0",
      revision: "d2753ff499af5e3423a98d3f36d3377129df1bd8"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "021104fb92832ba2623d1e14790da682c0688c6baf106707dc007c53a52963e4"
    sha256 cellar: :any,                 arm64_big_sur:  "08d15d09fff3db3121966746d8bac527383cf89c7ea33e36d66e9171fd1a65bf"
    sha256 cellar: :any,                 monterey:       "084302e7e5e47d46f1ee2f809161b94acf7d32fbea9035ccddcc7dae6b5bb0a0"
    sha256 cellar: :any,                 big_sur:        "d2258d96206bc121b6cf4a55376ffce267121286ddb339aa0065497c131ef42d"
    sha256 cellar: :any,                 catalina:       "ab35744d4222863b814fb8795cec8c4dcc59468a17692fbb7b33fe799b24c92c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7e93e9b4d34742c8ae3329b07874d7dfb1b2f16a003e71cdab358e16b93761e"
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
