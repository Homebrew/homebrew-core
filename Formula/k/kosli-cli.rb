class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.60.0.tar.gz"
  sha256 "7fd555e53413d965c1aca743e1bdc89565e00f0f99bcbbc26e77ee76ff11b145"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5f286074865719b7346510f5ac96556c078d16763b9b6a403d9d20ebc6af42db"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75587dba3a9d678c10b078655ce16db8f586ec65071c0fa2e7d2c07ab3ba182b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "262d2c0ac18fab4850c34196981a73b60128d6a609927e91b2f687a31377d58b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d97517d231db18bd3ce99550c9beda370e45a7511f6b3dc210b8ee2d26e968d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc3059964a4171c88f2b9af4ae6971c60c90347d08a6cf1d613058400cfd57ad"
    sha256 cellar: :any,                 x86_64_linux:      "58c7f51fea04201cc2f23ee9ebac82800f2af1bc9b04bd3228eed9d7ba13373f"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
