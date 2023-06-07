class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.22.0",
      revision: "01ee7fef6b8b3429e3668fca61f6142e8c08dba1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6703975af83de27fd513e7d6e56a73487f852c82981fab3e087bda5b205ac6c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2d464b100361b8787218cac631edbbe2f4bbfca681bc2be4a03a51cb1b49212"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09c832aa98d75057b71756cf1ecd9ad85b03967d6d2ff2cc2e1d4d0165625457"
    sha256 cellar: :any_skip_relocation, ventura:        "8a11cac15451f52905d76a443476ac25d4dc3cadb75d83cccf5f41a499cf8488"
    sha256 cellar: :any_skip_relocation, monterey:       "5c556f74630997fb653c77216d808486e3bcf354d37f30443475e7f5192bc84c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1b563c08511a53d14aa29765d4414b524d512257d0413d44948ca42c6ea8ad8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b6ef4f05eda1730bb83aa22f8eed87551caa19c122aac655d591976b0dc7893"
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
