class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.85.0.tar.gz"
  sha256 "d27082c0edcf787e9aac62649e720d025c71282c82621cafb07ee8ffc812b776"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf8ed776818a516cadaf122c6b10268f9a155541e0ebc79a7a07a2bf8948face"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bf8ed776818a516cadaf122c6b10268f9a155541e0ebc79a7a07a2bf8948face"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf8ed776818a516cadaf122c6b10268f9a155541e0ebc79a7a07a2bf8948face"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbc41c9e1f7bd2180c5b100c6d3f4cbc5a5b65dc8bba0862c4bab7e5b31c6472"
    sha256 cellar: :any,                 x86_64_linux:      "0006ea8737e0f9dc58299686036f2d83d003fb0c6b679f4fce7720b544ee01fc"
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
