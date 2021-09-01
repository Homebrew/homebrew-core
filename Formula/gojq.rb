class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.5",
      revision: "727b4b58cf84985ffdc61cf81677b37d757d7151"
  license "MIT"
  head "https://github.com/itchyny/gojq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24c07fb252a398a169b1a53471ff741f50fc23b4b00a4a369f3875bba3e45323"
    sha256 cellar: :any_skip_relocation, big_sur:       "587ab333143477da61713132f77b07c06d63c532082bb4aed1631447d58c9af3"
    sha256 cellar: :any_skip_relocation, catalina:      "587ab333143477da61713132f77b07c06d63c532082bb4aed1631447d58c9af3"
    sha256 cellar: :any_skip_relocation, mojave:        "587ab333143477da61713132f77b07c06d63c532082bb4aed1631447d58c9af3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b30bdac0ae58cb8c0a8680f14a1896adc30035abcacbcb330634a31ee5ae90be"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args, "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
