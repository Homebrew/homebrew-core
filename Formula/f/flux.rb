class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.195.2",
      revision: "c2433e6a9351b50e9c1c7de8a52a72176e08b845"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9d6a8a7113bff0d3fad44e9e52b80ef4bf4660c771ee42dad7cc210cf2288f8c"
    sha256 cellar: :any,                 arm64_sonoma:   "5d6804ec22c6a4e3d6a62dff38610d848880ae1e761e67b7911f2098b4ce1b97"
    sha256 cellar: :any,                 arm64_ventura:  "1fbb64166d19183afaa136cb4d2a9bace5e0bd30406ffecf1aa0463e57ab008d"
    sha256 cellar: :any,                 arm64_monterey: "50a5fb7f388d21ae20ced7ba4f9b8b8a7c5c6b322416786a5d7f5232480b54eb"
    sha256 cellar: :any,                 sonoma:         "62ba74293ea0038e39caa8fcda02fee03bf8fbeee7a2575e87a7e1dfb63b2bea"
    sha256 cellar: :any,                 ventura:        "885fdb467e7e27b997ea219c972e674794a333b1c9d9e86436d043669c71d601"
    sha256 cellar: :any,                 monterey:       "e4b79e24f763168081efc0b25bfbe1cb21fd8807c70207ceb365950a66d747c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e1b70709a8013fe55aa0d613b3ba05f2830cd43c8c0b1f2e599f3f3844d3a04"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  conflicts_with "fantom", because: "both install `flux` binaries"

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
    sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"

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
