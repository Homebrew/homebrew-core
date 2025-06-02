class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f53776a352b0f6da4abe5b163cb7d764ab9c580e8c44e001af2c46485eb3d4f8"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "539d6003120f02de12b1bde4060a3007004579fc0da8c274e4fcae66d236ead6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cfb5fda5a1b11305c79941ada6d9419b8f5d5007755a3e7a036ccca3b93d44a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea505098ec47dd2239ec175f15bec91eec340219b584001576831459db473c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4782113d695bb1fe390b255589340e957c1ad01901aca452aacb1491361f48f"
    sha256 cellar: :any_skip_relocation, ventura:       "7ca7ef4cf63338b31611340cf01d06bbb8a17dc72daa64e417c28ebe1521b77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67c493800b5b2c83a665017b7779d8e4802b46696388b57e398669ee63a90977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8e70b987d68306386de1a240463509cde35c92954e886f43a1b054da185ebac"
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
