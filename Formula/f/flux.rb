class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.200.0",
      revision: "b03b6bce7c27b8accc0cd00b12e32439a8fe19c3"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae45dfd6ac38b80d0a51f54238e8f30fd083c8788dbef6af6982581e25adf3ce"
    sha256 cellar: :any,                 arm64_sequoia: "46437c7561cdcf643a25338ac1868336806a0a47b6660187609cb930e1ee2ac4"
    sha256 cellar: :any,                 arm64_sonoma:  "f1e1c93f2ef4ec60b670eac5f059c7d5aaf634d16be1f5e71402c2a8d348d063"
    sha256 cellar: :any,                 sonoma:        "52d9852ab4ceb510ab4b73d0cfbdf3989d8cc90a19ef1881abf7eb3da4984287"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea06fb7ce18ad159293ee47f766b863f67484380ef109de4fdadcc680891f114"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14c58ee6001c00ef501130b2ce2f65b61b96f93d62b143ae4f58de3485f88792"
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
