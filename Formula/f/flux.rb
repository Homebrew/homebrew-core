class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.194.3",
      revision: "d8995bbfb3ad23bbd166a4daaea7a5d9e967dce6"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9fd5f5a00b55f3f3440f9210d48ce155a9f965fff7728d0336c8ef5b8a725c77"
    sha256 cellar: :any,                 arm64_monterey: "61551fb9307b35168d1897e5aabb75c5f8d47c5ebe4d6f2864d566c312e7720d"
    sha256 cellar: :any,                 arm64_big_sur:  "201a77449a44cbc675c6601437d855ef1480d6338bb31296d6903f8c5d2aad13"
    sha256 cellar: :any,                 ventura:        "d5d78c9fa3f721964cd9631c0fedb46b3967d28347d5e058c3618016ad1e25db"
    sha256 cellar: :any,                 monterey:       "0c2c8661e17b95573a8733981e7bc503c4dbb72f4b30b43bce905bf8e9c71301"
    sha256 cellar: :any,                 big_sur:        "7afbaf738fc20a543cda526aec0eb5f0ab0c446f224c7dc85a76475c6f31b819"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddccd7824b7152dd2931eb11f66643261a21feef071eceb9a572658be9319c32"
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
