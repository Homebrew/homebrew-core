class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.45.5.tar.gz"
  sha256 "cb0766677f228cf8291b6956365a713a5223f39ab64679086b6ec2a7fd8294b1"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d94fba35d7e16b1502c82b604d8f5a84800589601d61b0f4273d44012c07870f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d94fba35d7e16b1502c82b604d8f5a84800589601d61b0f4273d44012c07870f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d94fba35d7e16b1502c82b604d8f5a84800589601d61b0f4273d44012c07870f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee93af72467ff85df43cd1f32b682136acf24f0eb9f23dea39443549bd99f979"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da4764942b5bc87312b03529f1e8ef377d3e379afa0c248ffca19442f77f3f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b5330a04e84669a695add7d7527c99e3ce60dc00796591ecee79f2aebe5923e"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/go-task/task/v3/internal/version.version=#{version}
      -X github.com/go-task/task/v3/internal/version.sum=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"task"), "./cmd/task"
    bash_completion.install "completion/bash/task.bash" => "task"
    zsh_completion.install "completion/zsh/_task" => "_task"
    fish_completion.install "completion/fish/task.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/task --version")

    (testpath/"Taskfile.yml").write <<~YAML
      version: '3'

      tasks:
        test:
          cmds:
            - echo 'Testing Taskfile'
    YAML

    output = shell_output("#{bin}/task --silent test")
    assert_match "Testing Taskfile", output
  end
end
