class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.14",
      revision: "3841526b1e4f5797a039004a3da458df8b7f0609"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "529f9374e7ba514ce1c2cb615166431b61c7d11714f2d4b835478178d222ed97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "529f9374e7ba514ce1c2cb615166431b61c7d11714f2d4b835478178d222ed97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "529f9374e7ba514ce1c2cb615166431b61c7d11714f2d4b835478178d222ed97"
    sha256 cellar: :any_skip_relocation, sonoma:         "07ae1df1476e37eef154c4248aaff4441e3eca7e97f5b027fed3362d1b716e4d"
    sha256 cellar: :any_skip_relocation, ventura:        "07ae1df1476e37eef154c4248aaff4441e3eca7e97f5b027fed3362d1b716e4d"
    sha256 cellar: :any_skip_relocation, monterey:       "07ae1df1476e37eef154c4248aaff4441e3eca7e97f5b027fed3362d1b716e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2877464032aa00cdfaed2a994c687760d2ac91c914263f9acda6517d049e660"
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
