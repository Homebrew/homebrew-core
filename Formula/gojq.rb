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
    sha256 "ad78551a822854e217254f26bbbd525b682230f963c09d10ccf74da9836e5fe1" => :big_sur
    sha256 "c62a35dbdc15769f738df060e9958b4d10e33cb5ae0f5bc3230f376924030176" => :arm64_big_sur
    sha256 "92a338b37470bae5a7fe9806184433f936abc129c0e78534bc8ae96098116648" => :catalina
    sha256 "e1bae1fe7ee90021eb5733192e413a6584d3c49f29a458dfbf82630af32707c3" => :mojave
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
