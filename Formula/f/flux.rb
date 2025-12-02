class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.198.0",
      revision: "432969ffee5365e35d7519884e0b4d8e56cce01b"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b23050bb6cd3010245a47de797444de6492c4ccc2b7784c97c5e2c7a338ef148"
    sha256 cellar: :any,                 arm64_sequoia: "01aa831d3f045e062caad63ab72a76e34d049d5010f6059f05e879b4de94496d"
    sha256 cellar: :any,                 arm64_sonoma:  "e7b66b97749796bec83b2faa9e26e42db923df9522c5d637ebc6a1f3209a85d9"
    sha256 cellar: :any,                 arm64_ventura: "67432a04ff13d684b925700dbba1f5e3331df639a55f000123c389a60e7c9ba4"
    sha256 cellar: :any,                 sonoma:        "c13f56e132992d8e6b753f8e2358d5fb769fbb8232d67bd7e6feb2b7073e50b1"
    sha256 cellar: :any,                 ventura:       "fe981ddd62d62e89f406d66771b095b82730c9186a5a38c1c9d64f395a228b49"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "770477273abee5de6a91029bbcdedc4f6b8e9e8183bb4d73266d613db80cb30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6cb4a564936512e6de8730f584ec73b885fe156f144836ab13aa13be9b5feae"
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
