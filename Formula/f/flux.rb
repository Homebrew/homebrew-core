class Flux < Formula
  desc "Lightweight scripting language for querying databases"
  homepage "https://www.influxdata.com/products/flux/"
  url "https://github.com/influxdata/flux.git",
      tag:      "v0.196.1",
      revision: "ba61b9b27df5368b0fbf05df5bbbfcfb60c96dd7"
  license "MIT"
  head "https://github.com/influxdata/flux.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b6686adac661513f008b49b99c017158de41036cc5a49ecab3354f65c1d94f23"
    sha256 cellar: :any,                 arm64_sonoma:  "0825082d32c9df11d1350e7dee2dc8a6cf6de47b7a1bfaca5272750227666570"
    sha256 cellar: :any,                 arm64_ventura: "97fc685fa00d084bd8f0efd2e573cfb7f415f6ba1345fe9a36e5a395499869d7"
    sha256 cellar: :any,                 sonoma:        "e61e9d7e89ed29cfccb6d7855348dca8ce2d88ac8076f5b00d263374f7bca4a6"
    sha256 cellar: :any,                 ventura:       "9378570b7b39faa410f873c2d2973cf98c8e627aa9ea0e31efb435cdcc41a5ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff900b3355d134a5d1ede2c417a4858656f4e307ae9894ab5be092037e2feef6"
  end

  depends_on "go" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
  end

  conflicts_with "fantom", because: "both install `flux` binaries"

  # NOTE: The version here is specified in the go.mod of influxdb.
  # If you're upgrading to a newer influxdb version, check to see if this needs upgraded too.
  resource "pkg-config-wrapper" do
    url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.12.tar.gz"
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
