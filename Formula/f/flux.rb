class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.197.0",
      revision: "6f5f1c0c24c7da7a705f9805c2782ba091599c5f"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "97de1a79669a9890e7d710ef00ca4ad477303d483b968b524a5f3b000b7d0f61"
    sha256 cellar: :any,                 arm64_sonoma:  "1ca9eb85d95123297eb05902831cdb0b9ddb27700129e47575769c1fbe2e153d"
    sha256 cellar: :any,                 arm64_ventura: "b828e246911d416cb85083473f322e5365f39d88976a2967e0bdd09bce1258ad"
    sha256 cellar: :any,                 sonoma:        "8667d1ed59e6f177b8a6968b644a64c53e7b8864ee7103dbea7adf43265da09b"
    sha256 cellar: :any,                 ventura:       "f2c79724912aa01c5165b3e48433344a131256c056690521fabd53610c0a20b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d193ecd70a69a9f1e6e0d3b530d6513294296b77e60f3c894c3d0b089a637666"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "769deabe12733224eaebbfff3b5a9d69491b0158bdf58bbbbc7089326d33a9c8"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/flux/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
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
