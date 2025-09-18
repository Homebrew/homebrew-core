class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "aaa01af349b7e1de8ede7dad2e0525d44d0af04d7e8cc5337afd8756b62184cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d08af601a0cb168e070c4e1f561ec1c4c2285d8c6cda55667bda487eb725ffa6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31dc013a1e837d9527fbe9cf1f26823cb2d4ed9c9f8c7a2f82854e4ae8a6799c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "489dfd7418d7ec5fce3526bf4f23133db19cf00ec378308700088df574832c91"
    sha256 cellar: :any_skip_relocation, sonoma:        "e27de0e3f9059c525a213d49d396f7c9e9080fb6d47adf437ceb671f493691c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67c4b011c82b0b85a31efd8c9692a5d50a40afe25c5aa63a869a66f5a7c04e5d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end
