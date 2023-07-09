class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/refs/tags/v9.0.1.tar.gz"
  sha256 "0fb557d1423765077522b37e64daca4883a1ff1c267b321e3822871872a8fa45"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07a6c14cf914c8a28712f15664d423e304123602a201d7785617beeee0bc0b4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07a6c14cf914c8a28712f15664d423e304123602a201d7785617beeee0bc0b4d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07a6c14cf914c8a28712f15664d423e304123602a201d7785617beeee0bc0b4d"
    sha256 cellar: :any_skip_relocation, ventura:        "199641431b9455f5365412dc831afbac276a29ce4ea9bcdccbf4499225a610a0"
    sha256 cellar: :any_skip_relocation, monterey:       "199641431b9455f5365412dc831afbac276a29ce4ea9bcdccbf4499225a610a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "199641431b9455f5365412dc831afbac276a29ce4ea9bcdccbf4499225a610a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ece6f2e116b03bc1da23a32eeb6117f3959deabd52aefcbd3a4be07a443773d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v9/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v9/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
