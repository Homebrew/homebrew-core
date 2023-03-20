class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.12",
      revision: "655bcab1776ce6e6f4fe7831cf9d903c4630b693"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d757ed64f66ffe3e92242a65e79f7a7ec2f28836b44099acaa3f1e3bebdb9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9d757ed64f66ffe3e92242a65e79f7a7ec2f28836b44099acaa3f1e3bebdb9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d757ed64f66ffe3e92242a65e79f7a7ec2f28836b44099acaa3f1e3bebdb9d"
    sha256 cellar: :any_skip_relocation, ventura:        "596d61b2c7f8e3f800bbe3f3e0936dfed69d12761a78336f46667a0a082aaf08"
    sha256 cellar: :any_skip_relocation, monterey:       "596d61b2c7f8e3f800bbe3f3e0936dfed69d12761a78336f46667a0a082aaf08"
    sha256 cellar: :any_skip_relocation, big_sur:        "596d61b2c7f8e3f800bbe3f3e0936dfed69d12761a78336f46667a0a082aaf08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd15d3269c8505979f3424c1f630e76ef44738df9490bc2be17621fd597b21fe"
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
