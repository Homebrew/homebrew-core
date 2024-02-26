class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.46.1",
      revision: "8b7feb3a1c55b2f9c67d6df29f48747053200203"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85099946f7bb334a89aef57a75242da19e03a3c2100de44c50c343cd2464b3f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183b64a11330160faea29d7ab84af9d6ccfa93a115259c6ba4dcd8ad8216ac99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66c9380f85047a46d43b27e2d246070967b4fc2114f57c27d145fb9ee13442cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "68619ccefcbcf5ee71f0eb806cf8da8ceb98476156d40b22b31e06363ca6258f"
    sha256 cellar: :any_skip_relocation, ventura:        "42e11b68fe1d3d6ec4905d03164a3eb2fdfaede9d65d5b58b7b875056e1c2fcc"
    sha256 cellar: :any_skip_relocation, monterey:       "54d51337052e61418b1a41c92480742cd4ab9863c96102c13963824f924cf0fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b33c88a2355fd0d2c9b92b05d02898f12cb274a206642985f2ad5373003af8b6"
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
