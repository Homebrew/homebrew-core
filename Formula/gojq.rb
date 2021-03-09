class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.2",
      revision: "94879363409d5695fd8aee3bb6facd6823697320"
  license "MIT"
  head "https://github.com/itchyny/gojq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5b738d3326ff396214465e2e81347458f5f9de47e8c744f42da1297a46dba76"
    sha256 cellar: :any_skip_relocation, big_sur:       "57b7ab77a581462c9e4874bdfa6f97410a6012ae8f05f7881bdec5ee79821e5f"
    sha256 cellar: :any_skip_relocation, catalina:      "5fe043ffc48c087dd7b876ba686c9beff9791c702493ac25e3ae1c0731a7c228"
    sha256 cellar: :any_skip_relocation, mojave:        "a14bb2e2c4bfcda8b21ae8f1f8dd811dfd2ffc6939f029e6b18235c3c19887f5"
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
