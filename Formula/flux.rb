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
    sha256 cellar: :any,                 arm64_monterey: "f97ee515febc38fc2397eb8eb9db9b2fa02942d85c7f1f38343c2f1ed13cf772"
    sha256 cellar: :any,                 arm64_big_sur:  "3e0afb706086cc504d5c4c52720a08458f326c4b2434b347a2839343c559fca8"
    sha256 cellar: :any,                 monterey:       "d6eb8fb03e136fbcece5a3a1f2cce1cdb6cc10312a7c2dbedbaf9ba832690ab1"
    sha256 cellar: :any,                 big_sur:        "7218b2c83cf4f7a19f14196518bac263a929bf55fe3989fdf136f926b180a13f"
    sha256 cellar: :any,                 catalina:       "c82a41b97baa70f25e5b4b022b0c1a5ba10efe21919e8c55ef43de07756d9bf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c40e736cccc187cb234e423cd2179c876f4865c1855907db30b4c9a44514ec"
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
