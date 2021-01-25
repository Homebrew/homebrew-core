class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.1",
      revision: "db66c6e5588ff5fe10894c308742227d83d53d90"
  license "MIT"
  head "https://github.com/itchyny/gojq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ef10859a41f744d081ba26f4467593c57f1dac524d553841b74a482358a9147" => :big_sur
    sha256 "b2752d8c63d2d28a97f60569a5a326b7dca63dc9f8e61976bb2a8b0a704483bc" => :arm64_big_sur
    sha256 "8e8bedd294840b9cecdecc9c4627847900cc125ca5431e10171b20ba98a04874" => :catalina
    sha256 "53772d25fd054b3999ee1eee79f5ce905203f4eba240d99cafd6dfa747aa7f87" => :mojave
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
