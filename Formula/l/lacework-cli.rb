class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.47.1",
      revision: "29027f5570cef9777bd3bf8a946109a7a9c840b9"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30b744f68612e0692fa0fc62443df5376047507ec904f7d4574f35281d8f67e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0c470c9deb054d95514a40ef099a61c9eb3fa9281ef0edd9d01fb1895aaf9c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62abfd8ae8ef3f4a5e702a502c5fdb4ba5c5597803158fa843c4b210e9e97f06"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf6575b51ccf3b28ee15dca975df9ad1fe7ef8748cd4ade6c1048d7a147931d7"
    sha256 cellar: :any_skip_relocation, ventura:        "bda313d184a70df9caa1d8ecfb64c31f13bea7c0b8bd1fedaf949f338763f33b"
    sha256 cellar: :any_skip_relocation, monterey:       "acdcc2c9ada2ab2792ccc0f30653b6d8d87637aca233bc3247e48ae14541434f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3dde5fe646f8e5638f599ba8af2ed43abcd4495eb73c32ca3437e52c2266ca20"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.HoneyDataset=lacework-cli-prod
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags:), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
