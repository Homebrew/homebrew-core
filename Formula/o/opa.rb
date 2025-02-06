class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "b8b1b6ab1773788fcb41c2a1f00bc7db8526980b7ee94b06cea1085776f5eb39"
  license "Apache-2.0"
  head "https://github.com/open-policy-agent/opa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57ce9fef97b054b41c64d67b232a3b717d6e681ab23f55f537b3ec72e2c7aaf2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2744e071de3b64740023ea4ea08f1b3698dd4e0d3ee14de48b0324625493c0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9269b41c92564451241d8edf56f6711698b6fb6f62d051beb81982ebc37adc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "e52cdc04d6bf8ad2a911db956b2a917a8f7fa88eeeed77e553fd6aa83e93bc37"
    sha256 cellar: :any_skip_relocation, ventura:       "9663de80788e1082841833d7b9edb46313fb89ce433a9aa7e59dcbcc84bf4873"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9968c447d6cd113fffcd013dc992f1366a9275d55c85f64a27f91bf84088cc25"
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
