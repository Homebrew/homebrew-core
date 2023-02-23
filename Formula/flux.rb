class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.193.0",
      revision: "726bf0653f99083a7486fc00a2be6abc3f859050"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d1a1124f38c5f4de90e3fcdc62eaea27903150c6c16ae67ed91c790f6406bdc"
    sha256 cellar: :any,                 arm64_monterey: "2ffc3d0daa3d96f4fd51594afb28f2c35807a7cc088a107b17d3875a9275e076"
    sha256 cellar: :any,                 arm64_big_sur:  "9b11998875fa7a8b249a37a7d5e5e1c07059d8110c8a96a388f19a2a45dbcd92"
    sha256 cellar: :any,                 ventura:        "880994846aee9c922a586ce47cf593ec6edc875280dc2930e352b1f964955bd4"
    sha256 cellar: :any,                 monterey:       "03073f30fce6a42070a9af54073d633588ad26bfdf97cb6d2ca4db7a8162e13c"
    sha256 cellar: :any,                 big_sur:        "d71bacf6f19f91e7dd6c15f938427f9b5733b68b10a145ca9eef191ab68f15b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac46621871bc9fae1f657dcb70c7e599675413ad868e24d728a621d286300015"
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
