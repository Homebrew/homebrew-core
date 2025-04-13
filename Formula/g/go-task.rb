class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.42.1.tar.gz"
  sha256 "ebda29f1ec14e3e78f6d1e89136822c8177cc0b6d214fac8b1f027abce3c9042"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faa5d2c0cd64faa5164cdcd0c99e6aa3ca49b7cb04faac3bf18239d426f67f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "faa5d2c0cd64faa5164cdcd0c99e6aa3ca49b7cb04faac3bf18239d426f67f96"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "faa5d2c0cd64faa5164cdcd0c99e6aa3ca49b7cb04faac3bf18239d426f67f96"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eee617a37e79e781478ecf6064dfa726c5ddd978c47498546c1e54828274b5f"
    sha256 cellar: :any_skip_relocation, ventura:       "7eee617a37e79e781478ecf6064dfa726c5ddd978c47498546c1e54828274b5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1119df7993b26ecfb59996e6896b14ad93333f900e71d07b489995f50723233"
  end

  depends_on "go" => :build

  conflicts_with "task", because: "both install `task` binaries"

  # version report patch, upstream pr ref, https://github.com/go-task/task/pull/2105
  patch do
    url "https://github.com/go-task/task/commit/44cb98cb0620ea98c43d0f11ce92f5692ad57212.patch?full_index=1"
    sha256 "78861415be4e9da4f40ecff7b50300926f70fc4d993c3d83cd808040d711b35e"
  end

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
    output = shell_output("#{bin}/task --version")
    assert_match "Task version: #{version}", output

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
