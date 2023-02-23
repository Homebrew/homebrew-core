class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.21.0.tar.gz"
  sha256 "34b0d1ca1ef8b34246e9b3f9632635ae26fe294eb123a2d11c048a91a6401749"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bb8a8686516cc209814cfcdd83a99e6efea5d887aaa311ebb0e06c63d70236a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d29a717024f87d5b4ffd11cf10634dcfb5ab3dd70811ce14e502bf887d1029ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dec7fc8c28c12642d7bf7f13876c4f631e3aace61fb6010f106c0ee1615f1822"
    sha256 cellar: :any_skip_relocation, ventura:        "5b1263db6e54fc56c9ea8da2e582199acc63492da76c98e2035f10b6776a61df"
    sha256 cellar: :any_skip_relocation, monterey:       "86fccd6cd444f2b753c449a84d5cd3ead80e0486526bb0dbad30c0f526d4a861"
    sha256 cellar: :any_skip_relocation, big_sur:        "279477a22cfe8bf0204cc920d74ecd82cc77ffb4975a476f17d84f6cc6dfb469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93e9b4c3c94c87b5dcf70932d629f6ca23aa16b779fc787428b3a4cb02055a26"
  end

  depends_on "go" => :build
  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"task"), "./cmd/task"
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
