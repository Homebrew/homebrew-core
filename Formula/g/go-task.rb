class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.38.0.tar.gz"
  sha256 "09d597ed0618fd57dae944b61efa474f522f8d05d7ebeb0bc282cb5292b1d085"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0ba9633b8c995183f505f77968241d66e426cc0efded83c3638d7b1988b9a8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1605bcbc11649f3042bd3097b71ff0f939b4cb0bc92e23f7066918998fbf2c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9544a6435b8712b65f602225bcb6057860f988f39aac1064b6a44271cf065cd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "c9d7f0396ff809b2594bd041aa4a00179dc8cf26b951c4746e2c29554ba485c4"
    sha256 cellar: :any_skip_relocation, ventura:        "98b570026cb6a011bd4dbe2425926d10f29a784f728a4c795d809b9d67d9aea5"
    sha256 cellar: :any_skip_relocation, monterey:       "b726481931f13bba6dea21f54a33503de068b632943fb2782074af840b474601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a749e5a6c3dbda02fbd1811655b0a70d8f69c8aa0cd81c310213f8f0e617660b"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  # Fix ldflags for --version
  patch do
    url "https://github.com/go-task/task/commit/9ee4f21d62382714ac829df6f9bbf1637406eb5b.patch?full_index=1"
    sha256 "166c8150416568b34f900c87f0d40eba715d04cc41b780aa6393ee2532b422a2"
  end

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
    output = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", output

    (testpath/"Taskfile.yml").write <<~EOS
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    EOS

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
