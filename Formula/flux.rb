class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.180.1",
      revision: "7f1719d78efee78ccd7171bdd3c2062f29293285"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "37d915aeddcadf5bd7b71fd11093b9943a32f8f3d49569d0d6686a0279453b95"
    sha256 cellar: :any,                 arm64_big_sur:  "e5ffc2c89cd780a98d731596408286e7c2b5b54167a40bcde26217dcdef972be"
    sha256 cellar: :any,                 monterey:       "799e81e7a2d538aa7c71029f3cdd46c3dfbbb6b93ac0e726ee2241fc523cbe09"
    sha256 cellar: :any,                 big_sur:        "96fb9b19f217ffd8d2ac8b6a34e0102c67661ee8dafc8640958fdd572748d111"
    sha256 cellar: :any,                 catalina:       "1c0435cce14a471fbadbd10c065aa92fe2d4d8c724a641f465a8c73dbf394022"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89d9d08d1b4b80df5330bb2e6a03ac4806145c4fa92c6716adf10f5f5449ead5"
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
