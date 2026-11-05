class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "a21e3dceff91c079af1ed30e84ca8eb365bbc1cf2edd68246cf91568968f13e6"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0872b5663af489cc9b4ef97553b48468b207c90b0e0c6a04547d491f13c7cd3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "020f169630dd87ff8d642918fca16f8a48af45bf5ae92257edd1fcf563a5ac50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ebc8622d9375b72f5e97f01e404d23d3b9a230f9f10b5c9d9a114ba46d7c9c89"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "623debfa9203fa9f6e2e92ff715925d69de2a4e12f3a9623a843274acf8140e6"
    sha256 cellar: :any,                 x86_64_linux:      "c2f6fcc93ddf18bd70d575931b24311225ccdc5ffab670c12b62a69d28651087"
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
