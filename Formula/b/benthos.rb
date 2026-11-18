class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.85.0.tar.gz"
  sha256 "d27082c0edcf787e9aac62649e720d025c71282c82621cafb07ee8ffc812b776"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0df2cfc096a267e2b10556e8da39e8471472a0f97ff7db98854bd80cdc5a6024"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0df2cfc096a267e2b10556e8da39e8471472a0f97ff7db98854bd80cdc5a6024"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0df2cfc096a267e2b10556e8da39e8471472a0f97ff7db98854bd80cdc5a6024"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "46cae72f0d9e4b3f1fab890b7262d24b4776bd86d0f21cf322f862c47454685b"
    sha256 cellar: :any,                 x86_64_linux:      "306603ac5c4778a746405e2e73696778048547871c613f11dda307d0eb991be9"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
      ---
      logger:
        level: ERROR
      input:
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
