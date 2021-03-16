class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.21.0.tar.gz"
  sha256 "a7ea80f01a0c1f885df402d58cdf1889e6cf98c97d23037b82f8d0aab5eee918"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "255084c09d351cca985cc49b7972d7397ba1bad25040a559edd3550ef6ae70ef"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d7f9febd4f0ec4ec29c81bdc8a514916de22ce3a7f1fba9e6901b1a1f91515e"
    sha256 cellar: :any_skip_relocation, catalina:      "d8a85d8a40e0d6abeb0d0b400fcc549bf05a033df2be1306ec6084d8d5208b9a"
    sha256 cellar: :any_skip_relocation, mojave:        "b75cfe9a7b3aec5d13c70ded3d937a0e7bc5fcabbce8590f20bce587827eba7a"
  end

  depends_on "go" => :build

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
