class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.20.0.tar.gz"
  sha256 "95a96985f48bd79f6150146ef13eb8e6de975c3f137875749734c6fc6a53e392"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a8867fb1391fa15d5916cd4f3b17c3048fec255ced1429535820e82ff752079"
    sha256 cellar: :any_skip_relocation, big_sur:       "4261646689c01de6607d19be1f71454f5b0b61bbbbd2e8cef9de538099d2533e"
    sha256 cellar: :any_skip_relocation, catalina:      "cddc52e879ecff34a7eb06c911dcca9a72e222607cd0547564899eedcc8e5e19"
    sha256 cellar: :any_skip_relocation, mojave:        "a9767e6fd2659396cf211d3d971e4c84f4fa9bc355503bba412c9c9cc797a72d"
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
