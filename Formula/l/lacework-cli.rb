class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.44.4",
      revision: "1c354b5f88909a082f1952bf90ddd0bc73330a79"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cc6ad1a7efe2f94f160fb2ae149fc3e4b1050b2af754873d47c6c77b875bbde"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc3b3ca646e724a401d882b00d59411f697ece92813ebdc214228d1542a96400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1a6a5294cca31cf9dc9ebf8712d02c7e9b68a54181865ce94eb2fa23e2ad78"
    sha256 cellar: :any_skip_relocation, sonoma:         "39387ebb37e53db5bf70f6f0f1be8d2e088f85080770f62319db795326bd8af6"
    sha256 cellar: :any_skip_relocation, ventura:        "d815171cb7cc0644d93bac0ed8d38b3268ab68a2a74a6ede7730d72e4440f381"
    sha256 cellar: :any_skip_relocation, monterey:       "a11b95c8e322ace56501d46f5b257cd1f658797825db478d818ccd2fccc2e516"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7502d199d326033e30fddf782a61fc093e63fc41423142041aea7180ad322302"
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
