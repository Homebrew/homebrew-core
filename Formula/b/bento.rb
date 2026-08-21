class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.21.0.tar.gz"
  sha256 "be2506fa45f64a3c3fe2f3787fab39d704505d0b3b41c8a044c6a936e95034ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0c661ff3a16bd58fb715d9efd68631b40885b09616a7efdfc0d5a5a4bf70832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9fdce4794cd2a594943649c65159b53076cb6a1beeb0659206bd45554b1757e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2caab89fc4c85f4e3c01f0dded953531feea10d8971f04cf97c4829de61e8f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a717867f65d0c91f9b155c6062cafbd099c904990ca0af3b658b28ebdaa06250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ca30052309123b7e1a1c5e9f7d15e2789e93a68a590310643ff4302915e0557"
    sha256 cellar: :any,                 x86_64_linux:  "b449c2f235feae8c6bdfa19874c7fe60253ce39aed470f3ad40f3e672470f925"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
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
