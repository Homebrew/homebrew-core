class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.19",
      revision: "b7ebffbfc038677520df0bae4c8c2d877f88ffea"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8de3e810c66fed0188b58bef39125979ba6c4caf159401c8e2972efc340b76d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8de3e810c66fed0188b58bef39125979ba6c4caf159401c8e2972efc340b76d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8de3e810c66fed0188b58bef39125979ba6c4caf159401c8e2972efc340b76d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "47394fe55df1ddf2d82ba5c0a598c6639efa44c7888ed121db3667359a5cfe45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f24d5472b589c533aa56b8b10dd906d8d8ec5b0afc04c919074065b06b70608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710783baeebc1b41002428920e1f460c70cd8df53af3c1e47c030d3d291d1daf"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
