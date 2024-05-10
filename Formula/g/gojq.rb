class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.15",
      revision: "ca9fd97cd6247319f0bf999a670814bc1a3b071f"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1469196e6bf50d7381b243801d300b2a9b9446dd0c98bc4466a22531fead523e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1469196e6bf50d7381b243801d300b2a9b9446dd0c98bc4466a22531fead523e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1469196e6bf50d7381b243801d300b2a9b9446dd0c98bc4466a22531fead523e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0d52806fee96983e1ad4b10d24307159471bd452c0953d7499141f842cb63ce2"
    sha256 cellar: :any_skip_relocation, ventura:        "0d52806fee96983e1ad4b10d24307159471bd452c0953d7499141f842cb63ce2"
    sha256 cellar: :any_skip_relocation, monterey:       "0d52806fee96983e1ad4b10d24307159471bd452c0953d7499141f842cb63ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cee4fbc92dcf008939742be828f7430b31a38da12eaf5575955af43af405394"
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
