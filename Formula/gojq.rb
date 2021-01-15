class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.0",
      revision: "203d5e1dfd435460500ea5b00f71eca48bf1cb88"
  license "MIT"
  revision 1
  head "https://github.com/itchyny/gojq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8937d8be16fa3f13d0e9f971d2d7e5c0ff0f8cb4cfb02ec53d72344ecd84cf6" => :big_sur
    sha256 "7ab6960bd90fb64aeff25ce6af2fc96e1bafc2128501e4096e6f4fc442f1034b" => :arm64_big_sur
    sha256 "522b3e31ccd269471af44917ecde15099000bb78505bbf31d2879faa1af7af4f" => :catalina
    sha256 "dd0167516da92c42f829858caf8fddbb8ee55f060ee622fd187fc10bd25c0a0d" => :mojave
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
