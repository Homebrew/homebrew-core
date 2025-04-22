class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "e0b34157217581a0e7936222d267ae95f3adcf9477b6462298924ff64c943ec0"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280ee6e3d94aee4587c7da6145014cca7b74e5550740e5cb3998f6f4c684ce0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69ae3a249ee3e5ff382a8b6d1af3034ddbeaba7e9f02dded1a640ce4e9ce7718"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c2951a28901b0af624ded261a9b212fef655f1548bf16ac0a6a3a0ca298b6ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "c482d80c6bb3fc21b6051fa413fd1175e59f2231df7574a5ac8da41d433fa219"
    sha256 cellar: :any_skip_relocation, ventura:       "1812f9e20c8d4e05c7adf37b791e9c8bd90a2c6756c202a76d2dcccff4a086c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17aa732162a5a93e055206e495d8cd8002cc2230b3ca56c4fd4ad486fc2f1b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6109db9bfbd3f11eb32a718cee85d62d52fc1fe26411cbaf2f33674132482f26"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/karmada-io/karmada/pkg/version.gitVersion=#{version}
      -X github.com/karmada-io/karmada/pkg/version.gitCommit=
      -X github.com/karmada-io/karmada/pkg/version.gitTreeState=clean
      -X github.com/karmada-io/karmada/pkg/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/karmadactl"

    generate_completions_from_executable(bin/"karmadactl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
