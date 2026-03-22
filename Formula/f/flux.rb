class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.199.0",
      revision: "4d5be8002de15b192ec7781b3f3b0815235ec316"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "92439376ca69ff4f1cc6fbf9e2919df9922b9400808767cc5a4701e5a14f32d3"
    sha256 cellar: :any,                 arm64_sequoia: "1c70e2977faecab1dbe544923c40a2f481379b5d30a81cabda8fbd1f99e92c78"
    sha256 cellar: :any,                 arm64_sonoma:  "5be0260655c59d573c2ed3d7c902e37991626e64106c1634fb3cb35ebe7210e5"
    sha256 cellar: :any,                 sonoma:        "25b8f043f3f68a1e15ee41a42c1ac267d760c183b1affc0c9b902383774dac6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9897e2edab7c9c303704b04de67807b82e062b7256d6d13249c1908ff07b6c86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19eca4bdb796d7924eefdebf3a06f60f10aa8a1e8a5e59a87794b5aaed239f6e"
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
    # `flux-core` Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
