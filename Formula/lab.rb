class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.18.0.tar.gz"
  sha256 "b34b08cb20d16f541eb3bf428e0224b4905ee40bda9394e7da4df756ba1aa109"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d80095f9432435323f48a778cdd0c9a318afd2bacad9556ac6763be5d31ee8" => :big_sur
    sha256 "930a1630d07a98a28264b3dffc336eb51a8d98530fbdfdbd9a6bcd4a92c901ed" => :arm64_big_sur
    sha256 "15c50154f5322e57c48f0242cb5d234922d5dced1eae5b1aed6071c1133a203e" => :catalina
    sha256 "11715b31f5ed38d3e84af0530b354ac86027b08bf89f8f0ec27509b0a1f7c408" => :mojave
    sha256 "08c8bc4ad5de8a819b4d9741bb9c94a923b5373d834d9d88b044053aa5596b24" => :high_sierra
  end

  depends_on "go" => :build

  # fix the build and remove in next release
  patch do
    url "https://github.com/prarit/lab/commit/4f7ea880d638647ec907f7e5e6395498588b7bcb.patch?full_index=1"
    sha256 "49e571927e5b85c226eacf55ad0b3918932ee526703fafb01002b541b011e80a"
  end

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "bash")
    (bash_completion/"lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "zsh")
    (zsh_completion/"_lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "fish")
    (fish_completion/"lab.fish").write output
  end

  test do
    ENV["LAB_CORE_USER"] = "test_user"
    ENV["LAB_CORE_HOST"] = "https://gitlab.com"
    ENV["LAB_CORE_TOKEN"] = "dummy"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"

    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_match "haunted\nhouse", shell_output("#{bin}/lab ls-files").strip
  end
end
