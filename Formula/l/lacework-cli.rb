class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.42.0",
      revision: "8ebb18dbf3b324e401ee04b2ed45d3bb37566f06"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29c10011c5fbca9ca0dd505071ed8c62e6cc3ab0b85ee1fbba8b4190544d7fba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2f3f5700516ff40af208a57c7250c7b11ea04b5b941f67f6fa52364b4140fda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd713e3c29aba6cec3c3cb698760f5d1cbf54bf6abcde38d1f3d3651436691d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "0bf43bcb6ab3eb5252f8f265ee41fa260732c25c360742d3a99b6e72d8bc0903"
    sha256 cellar: :any_skip_relocation, ventura:        "6358eb29df85460104e3a759c6014d4c081b9975bf296365bb2991701cc739af"
    sha256 cellar: :any_skip_relocation, monterey:       "adda3c25543da23f5ebf15272ecaaa815ba986a6b3461908df7393a0cb1e49d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efafdd0f4bb41b16d491e0194a1f697f14782b44e2cb37ab48d4e36a8d516115"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
