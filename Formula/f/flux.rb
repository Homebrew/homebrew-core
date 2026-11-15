class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.201.0",
      revision: "9eb12f7f4702875e79189789cf9b3ac560499c11"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "399faa2f12659234da6613a26e9bce85af7758b63bdfd173856b25feabdd9456"
    sha256 cellar: :any, arm64_tahoe:       "c87754b70aa3e19467ca11fb6b22530cf25c85c9f04a5d5490653ac3893cff4b"
    sha256 cellar: :any, arm64_sequoia:     "c2e78b7b485ddd1c8373007123b8001c4b2c07a99e1f41762c13822237caa7e9"
    sha256 cellar: :any, arm64_linux:       "6539bec1e570b8e4eb08a663f57a95358d83354f4db6c276e7ce9b7e468fafa3"
    sha256 cellar: :any, x86_64_linux:      "d7275179456b4ec85ff941e6872e0abc726ddbfab886a263c7ddb895bfb179b2"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  conflicts_with "fantom", because: "both install `flux` binaries"
  conflicts_with "fluxcd", because: "both install `flux` binaries"

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.3.1.tar.gz"
    sha256 "11776c4f44b4d338619723cba1a6ef716573e80a358b0943ff2e2a86129ca8d5"

    livecheck do
      url "https://raw.githubusercontent.com/influxdata/flux/v#{LATEST_VERSION}/go.mod"
      regex(/pkg-config\s+v?(\d+(?:\.\d+)+)/i)
    end
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    cd "libflux" do
      system "cargo", "fetch", *std_cargo_fetch_args
    end
    resource("pkg-config-wrapper").stage do
      system "go", "mod", "download"
    end
  end

  def install
    # `flux-core` Workaround for `error: hiding a lifetime that's elided elsewhere is confusing` with `rust` 1.89+
    ENV.append_to_rustflags "--allow dead_code --allow mismatched_lifetime_syntaxes"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
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
    system "go", "build", *std_go_args, "./cmd/flux"
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
