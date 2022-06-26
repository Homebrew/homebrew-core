class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.8",
      revision: "32b97370e1760219848be610df190b1ed8fadec8"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926f8b3f1bc5ac9f33dbb7733ff9ac2da19b0e626715e8bad320f3bee7775f8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "926f8b3f1bc5ac9f33dbb7733ff9ac2da19b0e626715e8bad320f3bee7775f8f"
    sha256 cellar: :any_skip_relocation, monterey:       "13aefa1b11c79b4f6f4ef66882cc102df3455f3f79f00d500794a580b322ddf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "13aefa1b11c79b4f6f4ef66882cc102df3455f3f79f00d500794a580b322ddf9"
    sha256 cellar: :any_skip_relocation, catalina:       "13aefa1b11c79b4f6f4ef66882cc102df3455f3f79f00d500794a580b322ddf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ead21505b901efbf5c753d058db5bacbe264c836ff5758df4cc2fdf32394077"
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
