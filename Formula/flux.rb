class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.187.0",
      revision: "a82eda2866821ba1c49c0b6d25354586ddf2e77e"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "520af23e2e24f10e422bc9718f19efe824d652bb20bed0615fd380e1d7e6496e"
    sha256 cellar: :any,                 arm64_big_sur:  "f81611170aebdce42a689355c941a3640c118a1b9cf77b1b9aecd8a661adc856"
    sha256 cellar: :any,                 monterey:       "deaab75a5585445c3053b3df69619b4ba1a6aff5300cf56d37aaa6bdd707ab93"
    sha256 cellar: :any,                 big_sur:        "e69064a45348aa2bce5e7fc106178f077d137fdb3733e512648b384214f4f5f8"
    sha256 cellar: :any,                 catalina:       "1fadfe24a13b03c9e5d818fb5bbfdb1e987bb772a1f7a50511eb16f1a2779ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1e0b93e5bfb979f63750dc068c322f35cc3372938b9c8b226550f18dbe45906"
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
