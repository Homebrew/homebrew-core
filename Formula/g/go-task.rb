class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.33.1.tar.gz"
  sha256 "8a107464b379044a9351080c139764c896ec7c57266d870b6247d12f44cd37d2"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7136fd7780940a839c217437fcca6be06192bac093c1a515e5a449eccb5c39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f92a0fab3a62d782d4a626df02c98d10f1ed498a16956d1be94ffd9a52f24de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57e8f98f958ae1933108da50e3d07d86d939f806c8efcc3738987111c92f906e"
    sha256 cellar: :any_skip_relocation, sonoma:         "6a87b229e68282c78e498e5794480e9b38db29f7b2d647625457363b9b2ed7d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5988ccc9d18776c8fb5268f56389d9f261ab7b17ba4119e75bda2964caf2aa48"
    sha256 cellar: :any_skip_relocation, monterey:       "f325e3571d7f45404297e1d5bdf3e22ee435df6acf1ff3e7865fc2889a1ea2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "315ef6181a67539f00b0a7b71094dd1f3357f848823c02ed6311141a2570e277"
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
