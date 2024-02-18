class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.34.1.tar.gz"
  sha256 "1d0f2bc675f4b7b1cea1fd5799a1f5d1c917b1a73ac98f18eefdd41ecb030fc1"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5f7689c3ec190bad60240f0bde1ac21123fcb2df0f366c7a55916a9da7c6270a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e52ed7cb23b1462ff2eb5248169c72813eaf6a1d3c1a8cace229c6dc49c85bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59ab17c55e03b589cdf0a8ac7ef229ca52f2726141584432a81bb4062bececd8"
    sha256 cellar: :any_skip_relocation, sonoma:         "71776a7bf925a14ae936fce2d6820437487bc01821c6117c05fc9c3dc2987622"
    sha256 cellar: :any_skip_relocation, ventura:        "7c818701d0b65412464755fc0b02831004929d28fe7dcf67ee1a63b2f742ce36"
    sha256 cellar: :any_skip_relocation, monterey:       "a5eb49d0d8ce2d52dc403f585e2cd82071b4814daf0b540967dd75a608d6ddc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c80e5f518fe516feea81580ad898ca60b5b09d2f09f636c7c6f9dc97b971c05"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
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
