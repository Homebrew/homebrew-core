class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "3689adff37794f117989a0e57f55f49eb4bcf6872560368cad14624d4fd4ca88"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b55b3d9549ee2b96808ccda3d514f639034493015d9af2da45f3c7f1329de90a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca3194c75bef725ff3d49e5dfc09c58ff9bb63d00e1eaf96a62531c598513bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c87d497e9f924d5821909640629211bd12dbbfb4c770aa75a5c5498207ba82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf3afa62105c7fa71507a699588d440ddce67d0f203d76d1a932d0e2ca1b0bb"
    sha256 cellar: :any,                 x86_64_linux:  "5d0f778b7a36275c55c90b4a977db28db6b71499e0489bc7d4dd6aed42f5e61d"
  end

  depends_on "go" => :build

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
