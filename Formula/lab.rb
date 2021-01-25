class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.19.0.tar.gz"
  sha256 "7d8c3c88ac944b50137200ef565a42029e590bc66edb8eecf74ceb7aa0c0b908"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "151c2058f572bd93f607ea16e5c2f54bd5d927a9cb9634cfd8c3b8cd1a9079e7" => :big_sur
    sha256 "4a809eacd2ba1ce4bb3e8b944c8e1f18ea9b11195b6abe5cee86b7df4ecbb252" => :arm64_big_sur
    sha256 "4ab9f56d7969ef005cb72613a8bcbef6765eacff3bf5c808c5c4d4dc56138e0f" => :catalina
    sha256 "b8c28ac2a824aeacec68b184568c8189ffe2576e0edd93ed2f3ff0908309b64b" => :mojave
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
