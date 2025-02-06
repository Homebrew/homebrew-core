class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "c1dec5452e0e1c5159231102e6a403e56ba9d33a8fe91298f4a05a539ceb3ba5"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d75dd18873003e29b278a4561f9d90f4d550a26d51586cc3362a3478e1ef2b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e38ed13c78a575e7d9f8b123ccd2dab30accf6a067d281081954b79760932876"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cba2f2e9dc51e902e45c04fa65e93d414a4d512a2a62f641cc2fb6a6e6d2743f"
    sha256 cellar: :any_skip_relocation, sonoma:        "16bc2327d99e237af4dbd215f96ec5db1ef122c48c8c3663efee554597c25da6"
    sha256 cellar: :any_skip_relocation, ventura:       "6df4092c4a98f018606258c7f8151d3139d7a16add3f6264ee62ad8696667955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057f9c7298444827ed69ba118c4ee763c649049095f0b0f8fdac650b78d829a7"
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
