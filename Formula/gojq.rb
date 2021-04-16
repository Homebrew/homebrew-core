class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.3",
      revision: "bc1af7c0980cd41218b5f04982a1d28850e38ed6"
  license "MIT"
  head "https://github.com/itchyny/gojq.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81942e2f9588e91c72e21aeb5464529f05e4d724c1c0d83773516f8fcc13b176"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b1a0a98e70bbba21d729c61605609f1055404790ed2ed92ecf994ca3307e1bd"
    sha256 cellar: :any_skip_relocation, catalina:      "7fc117302c80d1aef474f7e2d59c5d6be53de2f87a8de08b0b9349a085e61da8"
    sha256 cellar: :any_skip_relocation, mojave:        "3dd9b02a3d6b5eb08323052e23cdfd846003372c8cea96a38fb975352b33da7c"
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
