class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.23.0.tar.gz"
  sha256 "8f20d5f1931e9b5daa0aa2d30fc3176d82dcca91b368905a1e1c05e2b36254b9"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e6c5f7468bcdda2dd60824e289016e574356a3d12687200f483a3511813a96a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fc0866043b2825d9c6cd55768c6dbf6a5252ee81cf08d1ec972f2f0c63e75f9"
    sha256 cellar: :any_skip_relocation, monterey:       "bdf4b6b4eaa8cd5a867bbaa1c569896052687f777df2fdddc260ca6328e236bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf2122351ee8c417e167b9266f396d71c1bf076376920b00bfabea8b66d36be5"
    sha256 cellar: :any_skip_relocation, catalina:       "831ebd5e87cfe24b4867a3a08b4c3714a050cb100ef4138d338c3d4e947ec026"
    sha256 cellar: :any_skip_relocation, mojave:         "50e3df561e2df7c25b663adb7428cff384adde8f58129d1848b674200c132522"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "103f4ef8df39bd5fef22d6867c010fe6369da47c467bf67924aaf07f33464841"
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
