class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.3.tar.gz"
  sha256 "d8163f52694ead03cd9cdcbc07e8ae9a0be3f9c630e513ae056f108e9b0a011e"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "739e348fcf14666866600e9edcadb4a2a18467a8ac275c7686664e53b09fd29d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac6b90d0163a6e077eae2bffbc60ec9585c7a549312068d99c9e0073b2f36b4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6718d3b32ea67054595412cc225ffb52aac7a3094518afb1123d4f0756bf0bd7"
    sha256 cellar: :any,                 arm64_linux:       "e13159086b94e92a036f6fa9aef49edea2b89469ed04d6fc50fb60b5c98fc71f"
    sha256 cellar: :any,                 x86_64_linux:      "e2bf1f6d9914eb0f268ce59bacbffa83da66fad841ffd9330fbff9df1a664064"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end
