class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://github.com/jvanbuel/flowrs/archive/refs/tags/flowrs-tui-v0.16.6.tar.gz"
  sha256 "fe05bc00eaf9c89d2b03d313296eae94b19706a890573047895857a0050fda0c"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  livecheck do
    url :stable
    regex(/^flowrs-tui-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3860163923b967c4864573216419037d0e7620b1d43cf24448650ecedb2c8c67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8ae9a4ab2d0b065b6e447d4011269f11397289b29361589db3c97fa8cbca15b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9560b04831edeb7348e7b2202394930c3dae7ec2523edcbcad694775745d5177"
    sha256 cellar: :any,                 arm64_linux:       "32ea9af951250bb13348e50c4a6c460e9b99810d0abc7097e097fe6e299960e2"
    sha256 cellar: :any,                 x86_64_linux:      "d50460a985fb0146b4c84cfd68e726fbf14be63dc2b6489b6e04237afc550a5a"
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
