class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "6d0a02977bf857129067c8c1b695ced744600ed133758bddbfafb045222384da"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3364976fd6f1d887bd2336581b2df81bba3a1776bffa78fa82431941300f199c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9aae2312a602a5966bf03e173a9ca30723ffc4eae41086d421765a2ea4ddc146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "839dfdd303c38ef0f1b0db75cb12dad0954c9c4d097e6e64f525b51e70804b4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a81c4542f0151ab4502b7f43b2e5dc080778b13754206c305e4d7a4d8af93aa"
    sha256 cellar: :any,                 x86_64_linux:      "55fd7828cfb6e60e5bbc1bd75c064775bc10e514af945fc78f8e5b18f5e8f226"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/open-policy-agent/opa/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "┌───┬───┐\n│ x │ y │\n├───┼───┤\n│ 1 │ 2 │\n└───┴───┘\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
