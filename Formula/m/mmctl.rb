class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.4.0.tar.gz"
  sha256 "9b3115b2e0265ed35ca927a385a0383344f78729a447b6fecac283eea1a8a9ef"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94cde754b0a751990a1ea5643fad7c131eb7a5ac5e209893373a7e6e6a984cbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94cde754b0a751990a1ea5643fad7c131eb7a5ac5e209893373a7e6e6a984cbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94cde754b0a751990a1ea5643fad7c131eb7a5ac5e209893373a7e6e6a984cbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfdb4ab64653d1e60fcbbfbc918621ba98078c684b16f8b9ba15477bbc405b9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "168425cff8c053043f5c4d73aec9ae562f0ea5870df92a88b24817cf64284bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76e419e134a6d55cce77abb405defb68270b20b6a3d1efe856afaf3bc5235235"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
