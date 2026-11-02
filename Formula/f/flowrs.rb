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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41ba6e788b5b8aa862a1b20051a98c21544c2eb90e58ae9ed00cf2d8d2fc4497"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "451c82d3471084beb45460873a7ccbee7771d3dda50f1a9315dd787ce1fd3782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e29ab6c269dd3c36f87d77116a3e4947a599b6a93708c0eec0dce1892a464e89"
    sha256 cellar: :any,                 arm64_linux:       "c43c45b32f75e9766abbc9e874a2fcf7660dfeee7406ecedcccfe5e7b510bd93"
    sha256 cellar: :any,                 x86_64_linux:      "f5d8a378de3cc5f5675c17f901abea694be082fe0d3f5a2a696743fa25e309a4"
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
