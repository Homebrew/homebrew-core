class GoTask < Formula
  desc "Task is a task runner/build tool that aims to be simpler and easier to use"
  homepage "https://taskfile.dev/"
  url "https://github.com/go-task/task/archive/refs/tags/v3.19.1.tar.gz"
  sha256 "b4f6021777f87f261a5646c0092e1b7d6dd252c4fc84ded015b89e0dae59383d"
  license "MIT"
  head "https://github.com/go-task/task.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b8bff10c1c176b9051e22a880c3db111d16e63982c6db5f2cbe29f9f4ec45af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "faff8e6d0d3552bce4f89a29eabd492cc2ad22694db6d9c15e5aa78b3fbf7e41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1932ad59a5927d4552005fe71aea3c4bbd2deb46810df321c8c6095c365c5336"
    sha256 cellar: :any_skip_relocation, ventura:        "102da2d7f8bf18efc7aa164db3c7ae50bb85166eacfcf29eab0be888a47a15ba"
    sha256 cellar: :any_skip_relocation, monterey:       "21667c89808136f6199bb5877b0e5d06bd6789e7bf3a81961ca6705348b98872"
    sha256 cellar: :any_skip_relocation, big_sur:        "c36f14936d99b2f1ee0e431f6cdd63785d258fc59472b50b1e2614505f1cde76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd80e734c7da2f823878c9d4ad2d58d82caaf656ca92b7b5657f3afa2a3653eb"
  end

  depends_on "go" => :build

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
