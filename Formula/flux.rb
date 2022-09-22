class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.184.1",
      revision: "140a51b02f38c6b843499109f780f47326b9a1e9"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7b4b0f6a283506c641c70896e936b5e9dbd57872d1308e8c5d7131cd8e82e898"
    sha256 cellar: :any,                 arm64_big_sur:  "a9b316c4c0e709c7d2951e027d43a8b001f01c0544eda01d2995708d4aee8186"
    sha256 cellar: :any,                 monterey:       "479fe2233e8385888471e38872228befaa47ed817de018e40d11c28e0a8773cc"
    sha256 cellar: :any,                 big_sur:        "1fa4c6b6c6f21ea8b7e37a52b7e8979cd7828d1e0be9ca12480e6d6f8094b385"
    sha256 cellar: :any,                 catalina:       "c02874273f71e3df55445c989d6f1a09151d9b9794b49fa775d6131063eb9356"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcaafbfebb174ae0f0fc73f6758f9c44bef73342be293a73d49acc3847e8a05"
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
