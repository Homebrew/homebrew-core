class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.22.0.tar.gz"
  sha256 "ff5b184db71818d0c342788fd5b38ab7c7af8d8561c683b5d08ffd4075116a0d"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a47b94f2c4ffcae4f22d9a9c6c88b7ea47d46d6485e9ebf76cafa486b1e0248"
    sha256 cellar: :any_skip_relocation, big_sur:       "89edf68fded2470d74bc924ee7e48da8500db6eebeef55593620908d223c33c2"
    sha256 cellar: :any_skip_relocation, catalina:      "bf63f2cd4b9cf9bb5a930922e3cff4f5c75980372a4481034a83161612fcde2e"
    sha256 cellar: :any_skip_relocation, mojave:        "def57cae9479805aca1ee18761db6df535ce30e85944eb309fb2d37c27f90f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bc0dd7b453e67c13d7b02e7f4d755164af2560bbb80a40ebb7ec9314a26abc"
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
