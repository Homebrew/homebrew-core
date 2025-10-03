class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "90d370c4b0fe4084fcc2e35639348661e9e4d2a2149ffa955d45394e135772a7"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56c9e310d920da808fb3f7102b1626a5a1364259c33a984d4cdc15d198aabba1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e63351802e01337694543828b639509ccac743335a0a6cd8a65d15c854d00ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d8f1c939e3608afab2c646121f1ebef323ea974d556e01dbc51a34a6bcdc36c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbb766e7b563e151d94a99958c4ca87b077c9f46f3150a49e98c83959671e416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2843f1af717a9d79685a4737b179218de841a94b7fd542975c32fc8c61c7f1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/open-policy-agent/opa/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    system "./build/gen-man.sh", "man1"
    man.install "man1"

    generate_completions_from_executable(bin/"opa", "completion")
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
