class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.175.0",
      revision: "e811f6c85a48d1dc39ae62201194f971f42b427c"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7d5a9639a6ca1817ff586b347168adaa510d5b4bcf91c0200a7f460af4a88f57"
    sha256 cellar: :any,                 arm64_big_sur:  "93a14bca51be0cd5301ab55957f21abb916271556663f60030e05c72248447a7"
    sha256 cellar: :any,                 monterey:       "d5885a0fe23f747f7ce9f8e99b5667a45c7c15a3dc5e88a044b387112d1822fc"
    sha256 cellar: :any,                 big_sur:        "90799c7b98ca28be3108338a87bf700e2062908309b6642b7654f25e42f1c0e6"
    sha256 cellar: :any,                 catalina:       "deb4968f8026a53bbb38a7c96c9f9cba57051a029d0005a96b22c9270ac5955b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55594c90da30ec58972439e7ca4e84c47e781d1520c3f4871d8507ea973b52f1"
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
