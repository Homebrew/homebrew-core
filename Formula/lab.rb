class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.25.1.tar.gz"
  sha256 "f8cccdfbf1ca5a2c76f894321a961dfe0dc7a781d95baff5181eafd155707d79"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git", branch: "master"

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
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"lab", "completion")
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
