class Ggc < Formula
  desc "Modern Git CLI"
  homepage "https://github.com/bmf-san/ggc"
  url "https://github.com/bmf-san/ggc/archive/refs/tags/v7.0.4.tar.gz"
  sha256 "495f5f443986862e86bb95edbcbab36d3acb1a96c4a46945c43c2b461a40f47f"
  license "MIT"
  head "https://github.com/bmf-san/ggc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceeb963a55d8cc4e86c2c6c2db03d3983b26ad81d9e44d3fde4aeb0589115720"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceeb963a55d8cc4e86c2c6c2db03d3983b26ad81d9e44d3fde4aeb0589115720"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceeb963a55d8cc4e86c2c6c2db03d3983b26ad81d9e44d3fde4aeb0589115720"
    sha256 cellar: :any_skip_relocation, sonoma:        "788988450cb1897dc1a285bacee8fcf7bb6bfd7c4ecea1698c0d5a491df83358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e6ec994931f3ea6036c56239dee279a1efaeed98022b589246cba6ae83838c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c17fd850e4c4bd9e15b1a441981a9f7ff535da35375a37a47c29326ea956f021"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ggc version")

    # `vim` not found in `PATH`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_equal "main", shell_output("#{bin}/ggc config get default.branch").chomp
  end
end
