class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "f8cccdfbf1ca5a2c76f894321a961dfe0dc7a781d95baff5181eafd155707d79"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e797c832335a5532813bc21bb9b373cec8551469955c9dea5826787f0053ed87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e797c832335a5532813bc21bb9b373cec8551469955c9dea5826787f0053ed87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e797c832335a5532813bc21bb9b373cec8551469955c9dea5826787f0053ed87"
    sha256 cellar: :any_skip_relocation, sonoma:        "b06e95e8b55727781750196473f8664c9bf4389d92291a2c7093495875bd7bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a9bd0118530f93d8ad3aac66be05e8498fa0bf281a828292556cfdca35664f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da46a19b9c616c7d034b36032f9032cfd66a09b225678f6d9b71ed6e5a515aa6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"lab", shell_parameter_format: :cobra)
  end

  test do
    ENV["LAB_CORE_USER"] = "test_user"
    ENV["LAB_CORE_HOST"] = "https://gitlab.com"
    ENV["LAB_CORE_TOKEN"] = "dummy"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"

    output = shell_output("#{bin}/lab todo done 1 2>&1", 1)
    assert_match "POST https://gitlab.com/api/v4/todos/1/mark_as_done", output

    assert_match version.to_s, shell_output("#{bin}/lab version")
  end
end
