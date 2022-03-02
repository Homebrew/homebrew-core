class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.7",
      revision: "7d0d14d3627624028e019a1f9ecca6cdb6231297"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf7bede815438e456d70e06320a1978446458eb5d04d7be58774a18819cfb18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "caf7bede815438e456d70e06320a1978446458eb5d04d7be58774a18819cfb18"
    sha256 cellar: :any_skip_relocation, monterey:       "b54989ae9bb2edc65694af274051d280cc2b334cd3a1f67f945b2293163d210c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b54989ae9bb2edc65694af274051d280cc2b334cd3a1f67f945b2293163d210c"
    sha256 cellar: :any_skip_relocation, catalina:       "b54989ae9bb2edc65694af274051d280cc2b334cd3a1f67f945b2293163d210c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b9aa91a2f8dd3cd1e9d7ea0aac5364d2292ff167f75a8dbabba30a54720be09"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
