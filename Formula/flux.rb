class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.169.0",
      revision: "a9af7d07353944f8c2b919b961870f58cb3a2c20"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c9cf17c985b468accf5d094c065d22953b0e6b76c64ce66ccf2bc45b02ef27d0"
    sha256 cellar: :any,                 arm64_big_sur:  "49bf513a23514a2b97aa4ce78ff34505b522d6f34a65fbb28142591bf6c58c89"
    sha256 cellar: :any,                 monterey:       "7541eaeee1f3bfeb1ffd3c4cc6bef42610335b82b31d3fb00942cd017f6b4a48"
    sha256 cellar: :any,                 big_sur:        "837be47f8f683377cc26d62a66f3dbcda2b3e8eefb95535eb78651b8fabaa278"
    sha256 cellar: :any,                 catalina:       "145d511634430bd82fa1c4f2bb4841a64c1c91161ee692e15a6079b4fc0c6105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b96190540340bdc01932cc51740b3183e4857c2eeb826a4d78b6ec78f1a2180"
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
