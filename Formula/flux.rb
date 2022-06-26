class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.172.0",
      revision: "0bd05dd6371b4355ddbacf50a3eae51d5240d026"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "98abd65c2faa5c098c4b8a219d35849a3ab5f6f8a71445417aeffab6d7d84c01"
    sha256 cellar: :any,                 arm64_big_sur:  "1a32889a6165960867daf45ea027d0f2082036d55bb995b67a8ab07b14970818"
    sha256 cellar: :any,                 monterey:       "c561222f3d8a9f46196a8c50177e0992bd1d6f07bd551accbc9fd68ee0ee614a"
    sha256 cellar: :any,                 big_sur:        "289428523f5221a900d1c345a28c23329565252443885aa9d1439b2b0cdc86f9"
    sha256 cellar: :any,                 catalina:       "fd414a43c20a54298990c5de1af18a33f4ea17e6caf16abc3577cd28b8e1e8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1e732bf4d24bbb17a8ad793a36f1eef9b76ffce8f3b556248a7a6acf7abf9c"
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
