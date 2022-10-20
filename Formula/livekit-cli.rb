class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "35df3f6a50adffda3eee2b969d81cdae0e1ddd461c1c266142eeae9bde3c2b09"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f67b151905f323b53487f768985b690970e479c3e0d1a8dfd3cdcdcb50b3a79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fdad5496a482d20ce00f45716f201265bebaaf55f02d968fd7e84cf81dd0560c"
    sha256 cellar: :any_skip_relocation, monterey:       "a43df3ac45bfac34d857f116814f6890b2c48f847c468c6dd4a195fd5670e1ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cab7c0aa79a6750236202c9c549303aebc32e6d27b0d1a25324295efcd3b69f"
    sha256 cellar: :any_skip_relocation, catalina:       "2a23fb7d5ada8059a80422e2d64440c17266147e91b191b38252696ae5b8d6d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91fb9a5ae524fecf5c0826e914df0c3f18aa2e22c6ecf51167ff5d27b4311f5a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
