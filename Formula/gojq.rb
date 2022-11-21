class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.9",
      revision: "f2e333c56832b92658add0f4712994427ba70919"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae20ab88a0d61751df8346746695b346b33c6960653667a6ffd8af5489b9196c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89452cdc6c06c0a03a6a6b2c888795df2727f3751e1874aa0c3a4c17d26d46a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89452cdc6c06c0a03a6a6b2c888795df2727f3751e1874aa0c3a4c17d26d46a6"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3b45e3d4bc263db98fdd33f97cb44ad1b8dd8a949ca160f9f5afc863b4b2d4"
    sha256 cellar: :any_skip_relocation, monterey:       "df62983ad243d969a7f893a8259cf26ebbc5ae6f9c369aeca0c07cccb8243c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "df62983ad243d969a7f893a8259cf26ebbc5ae6f9c369aeca0c07cccb8243c88"
    sha256 cellar: :any_skip_relocation, catalina:       "df62983ad243d969a7f893a8259cf26ebbc5ae6f9c369aeca0c07cccb8243c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1b202fb288dc5c050c400a784abe0ffa70f8f681d064b562fc446895180764"
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
