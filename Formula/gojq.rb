class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.7",
      revision: "7d0d14d3627624028e019a1f9ecca6cdb6231297"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af1d459d464bba79cf965bb29db184411efbf7eab1e2cd715d1709bc7d7bf318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af1d459d464bba79cf965bb29db184411efbf7eab1e2cd715d1709bc7d7bf318"
    sha256 cellar: :any_skip_relocation, monterey:       "f61144c783de64cdea1ec7b4a1a922aa9f5cab54a38fa1499dba091a851475ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "f61144c783de64cdea1ec7b4a1a922aa9f5cab54a38fa1499dba091a851475ff"
    sha256 cellar: :any_skip_relocation, catalina:       "f61144c783de64cdea1ec7b4a1a922aa9f5cab54a38fa1499dba091a851475ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39040111299d994ef8af0a5c1fd7fe422def13be042dff3ef63234fc9b9b335"
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
