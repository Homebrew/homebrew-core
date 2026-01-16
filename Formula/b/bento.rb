class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "ff5260111eedd686645ec2bf259e61032af8a80043ba96fe87c9f11825ae8e08"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f27e3d749ced6e6c6a5604a533a9b1aeaf497936032f3b6294137be5f24017b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcad732c06ff70865c8f9d3fa01fb6d568b8eeaae78b02a0f29828e5772f9026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e804e886048747d8c3afaed2ab32e85fc9c91bf165bf93c80ceb6ee6f5fadb2f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e349a97355f0290b8a89366c477986ee0a2285c524403be6eead7f5fce804a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf98fc36f40b4097e89b029a3710f7fb013f56c4263e8d3a4fcfe815a3e4c777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "548c5c054996981da425ca775b032b9ff9606d6bd9d830fe8df610ec7650a430"
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
