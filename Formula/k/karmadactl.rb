class Karmadactl < Formula
  desc "CLI for Karmada control plane"
  homepage "https://karmada.io/"
  url "https://github.com/karmada-io/karmada/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "ebc3664cee6c8347ccb33107205d562cf1b610c3d868040e84943fcbc150520a"
  license "Apache-2.0"
  head "https://github.com/karmada-io/karmada.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b44e9d75233f256a1fb030c06f1e78b98eaf809df5f676cb8afb5e513125300"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a95f509e1676a6299d0bfe0dd112f1af29d0a57c5807178fc1c9c96888e04e7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e7cb733dfcce994edaf8d73ef6341124b2b26e796faefad548737bc508176f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "88ce949f8e535f5d19609fc308f8c9f9358e18bf337feb98eeb17d294f789080"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91f7b2b1f9166fbdfabb60aae45a03473585d190d1ac67a95fe7fe6463363a7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da189f0403cdcd3d7d6064c1dd1d8714d5ba7f8625e7c5c7d14824011261a4e2"
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
