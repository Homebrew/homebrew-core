class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "9300027b9d9d20904ed0306e5a7fe745f3bba8519d17e0f743cab52f3c574fa9"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6003dce9b939cde8c9778009829df39a949035f47a66b20a97fc9f7cfb6e72eb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "98e6283e63181fdeece944e10ff47c19923eb5c91f186ab97846075d35cce1c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f9bfa398ad3a06d30940ea66ff2f51df6dd9753701f4413ae3e7cc43e653e33e"
    sha256 cellar: :any,                 arm64_linux:       "5347ef5a4b23c96e2f952cad5af996daba5ce6166692a62736b4624ad508c866"
    sha256 cellar: :any,                 x86_64_linux:      "8ae2cf35ca70a8e3ff53f889586d3418e689b6dab7db3a80581f873818ed6865"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
