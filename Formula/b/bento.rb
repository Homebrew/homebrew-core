class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "3faf7f45c70f831cb7c115051c2d99dd0acd12c7ae380ac56d83ae520a5a84df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "834a7531f7bdf7acdcdb3d1402d771a43acea934fa196c6d804f13c3f2a6d171"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77051bec1c21c494abf207b42fec80ddf747f245257d848c605270f0dc2eaa8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b8b9281fdb4de9062793774ac53374fc76c98622b39ab3b60bec3f45ca62b67"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0ec115eb6023bfbcbda5a31824252181552fc7b3a5c458f124a4b534cd986a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc2a0c3722c81f0323c01c739d209a6c0e61eda68bfd21a41cef754886482a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc7bbaf1b92f5e176b0e6b3b170a6b1325a9068bbc6b8785dd95c99f1a080dd2"
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
