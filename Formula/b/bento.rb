class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.22.0.tar.gz"
  sha256 "37323b09e4f5f2c4213badacdee264488bfe6c934761f62249ac16e689440336"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b1f6236b05589e83777f1326596dd69e8d643e45aa3f08f45ac08b83c7d5ea7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9a6593767cc4195972da3ffdde69d6d8fe9da971f5bbdbbc085bd0a9810fa5f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bdb19355fa56a0be7334de6908c57700d941d51d856403c2dc697e845b0b7f9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5cc02784864b61afa60a2125b8eba138ad0926f9a23bb51fe6378c066b43cec3"
    sha256 cellar: :any,                 x86_64_linux:      "e6c7470774b967dbfee062964c780d19a15ebd99c24b96e00faad59199905d19"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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

    assert_match "FOOBAR", pipe_output("#{bin}/bento -c #{testpath}/config.yaml", "foobar", 0)
  end
end
