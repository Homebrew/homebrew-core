class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.22.2.tar.gz"
  sha256 "3921f8b2f828cb4c67ca0b6eb3731c44a1f11b569f212ce87b353147b110feca"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1128ccee736ca2ed1e22064928a45dc7c2eaa65720d3eb1c943f48a68d27b07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b0558e47c76348f7bfe65bf1601e062551fc634be8ee50b0e53bd64c1063fe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8d441597cda6914a619fc0a7db599e3e1a210fd289fcedb339d8c5b3569abc48"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d1eae07c99cf7873adde7c593aaa3722c758e70692d06bfc674c07a2a68ba30"
    sha256 cellar: :any,                 x86_64_linux:      "d21c72b67a1b2b29dc8a3bf80968471eb883cf9df2e087c29c491b0359c0b4da"
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
