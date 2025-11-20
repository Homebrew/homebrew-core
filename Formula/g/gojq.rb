class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.17",
      revision: "f4c2cfe4c7ef54436cc791250bc66cf33dc44c7b"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c3cec086b2599e9b73b7780db32228365107907cc03644642bd5579eda14796"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "523520da9c06c9603c8d049432177e302140c217308b421dd9da85cb2a6eea74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "523520da9c06c9603c8d049432177e302140c217308b421dd9da85cb2a6eea74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "523520da9c06c9603c8d049432177e302140c217308b421dd9da85cb2a6eea74"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8a965b5a81ec2ed412f0d013080967e8e1156a054258ed9313a1b24135b4991"
    sha256 cellar: :any_skip_relocation, ventura:       "b8a965b5a81ec2ed412f0d013080967e8e1156a054258ed9313a1b24135b4991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "896f31f71d784c99232d88ab938f219b87e2e8dd7c276f0b3015a89fc91735d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c7c2f05dbb80299cfbe4798429fd38fb3c24f8e05bb002c6285a1f280be48a"
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
