class JiraCli < Formula
  desc "Feature-rich interactive Jira CLI"
  homepage "https://github.com/ankitpokhrel/jira-cli"
  url "https://github.com/ankitpokhrel/jira-cli/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "2ac3171537ff7e194ae52fb3257d0a3c967e20d5b7a49a730c131ddc4c5f6ed4"
  license "MIT"
  head "https://github.com/ankitpokhrel/jira-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b28ca84cc12b9b5cafe2aedddb853dd68a5f0b43fc8722e6d8b0dce8c9b8d6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91860cbd93bab028cdc19f6d0097499049050e18c181e66a3484bad4d1610a55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92367821a0020a52765aecd50904a6cb04f095fc163094b39d1321a8e4e083bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d61858764e4b2a3e88223beca7231048d021ad6e5fd8bb90eff50adfadee0f"
    sha256 cellar: :any_skip_relocation, ventura:       "46b3447f914e6f26eb0abf2fd35403d956365f2a2495120985e00bd6932f0bef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3cbf5f20b5c662e9c70e4f5f8cbaae8ce78f5dfe634d5b084180aa314e5a13f"
  end

  depends_on "go" => :build

  conflicts_with "go-jira", because: "both install `jira` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/ankitpokhrel/jira-cli/internal/version.Version=#{version}
      -X github.com/ankitpokhrel/jira-cli/internal/version.GitCommit=#{tap.user}
      -X github.com/ankitpokhrel/jira-cli/internal/version.SourceDateEpoch=#{time.to_i}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"jira"), "./cmd/jira"

    generate_completions_from_executable(bin/"jira", "completion")
    (man7/"jira.7").write Utils.safe_popen_read(bin/"jira", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jira version")

    output = shell_output("#{bin}/jira serverinfo 2>&1", 1)
    assert_match "The tool needs a Jira API token to function", output
  end
end
