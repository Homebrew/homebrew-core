class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.35.1.tar.gz"
  sha256 "09fec550ce19f531ebb94379cea747efff24f6da2465e5a60c53cf8cbae0d9ba"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7ca63942c18180289cc49f0ae59b198adcfadb2af9c05777106746df0944d68c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa61302280c22b79ba1ee681db5d7fee1edeac5f8dd7a0fa97d141c0671eb633"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed628ed5a420ce60628922f92d599146455aefbe6a776895cda48a4447dc286d"
    sha256 cellar: :any_skip_relocation, sonoma:         "015cba8c68b7d6a2dce04a5841a75cd8ba5775fc79a3010f9df0a4161d0e4054"
    sha256 cellar: :any_skip_relocation, ventura:        "be6cb85ed4375074085c1ad51cfce9e8b2df452e8c662dea62d93e6c8de0be60"
    sha256 cellar: :any_skip_relocation, monterey:       "95becc7036ab39c36bcd480c768bca78c5afe57c2d56fe845da86ef97bb8d568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c939cbefd83b57b5fab0cb81b3c64ea3845e14571e5c9a4ae48be325a462e02"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    str_version = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", str_version

    taskfile = testpath/"Taskfile.yml"
    taskfile.write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    args = %W[
      --taskfile #{taskfile}
      --silent
    ].join(" ")

    ok_test = shell_output("#{bin}/task #{args} test")
    assert_match "Testing Taskfile", ok_test
  end
end
