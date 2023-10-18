class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.13",
      revision: "c882861ed1727ac715edf14bbcd0786173a42349"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92549bc8ddd023f849beb0035a7aa014776a8568aed8894f904dc560f9b3be67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "117a0ea1d137502605bd2ac32deecf715cfd21e7b6dd46ac1ba110ed07fcb327"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "117a0ea1d137502605bd2ac32deecf715cfd21e7b6dd46ac1ba110ed07fcb327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "117a0ea1d137502605bd2ac32deecf715cfd21e7b6dd46ac1ba110ed07fcb327"
    sha256 cellar: :any_skip_relocation, sonoma:         "e704ab45460fe39f0a8c59fad0ddcd71d6c5adc8111257d165e03797925ddebe"
    sha256 cellar: :any_skip_relocation, ventura:        "281a5794ae94e537b7f73e402fec5f1f3bb76026411e58849b1e06c85d64d7e3"
    sha256 cellar: :any_skip_relocation, monterey:       "281a5794ae94e537b7f73e402fec5f1f3bb76026411e58849b1e06c85d64d7e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "281a5794ae94e537b7f73e402fec5f1f3bb76026411e58849b1e06c85d64d7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ad9750090404adf97b09e05f8062851309918ce153bc5c13c34adc2386a8509"
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
