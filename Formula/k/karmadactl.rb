class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "e5365edc701a45fccd1df7f31136424a83bc6c511794ac8559da59a8e3c25ba5"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a96b6ee02ddbe055cf54ed9aa97a60c98e503b0a1e023facfc8b726b2d3bcb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0177ce84a537ff10bf55a7d026651f0558fe1def8287263ccaa5d6b13bdc4d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8adb989448ee0cb61645361bcd1a92b4e6b8c40608d194886f2ee2791f322bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "663266485b06de8de4377b75f4a878298171881e8bc202f959b6bcb7868a38ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "760106aa2602e48124de6b9f3a9b8a0d9b53be95cab89c5435813c90c252d33f"
    sha256 cellar: :any,                 x86_64_linux:  "7b63ebb7c1ec074a89a681254bcfda19d427e7c4b4fff49e1cd1c0c9df90ecc2"
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

    generate_completions_from_executable(bin/"karmadactl", "completion")
  end

  test do
    output = shell_output("#{bin}/karmadactl init 2>&1", 1)
    assert_match "Missing or incomplete configuration info", output

    output = shell_output("#{bin}/karmadactl token list 2>&1", 1)
    assert_match "failed to list bootstrap tokens", output

    assert_match version.to_s, shell_output("#{bin}/karmadactl version")
  end
end
