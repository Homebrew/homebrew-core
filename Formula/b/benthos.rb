class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.80.0.tar.gz"
  sha256 "7797b9ed34176f836c8facbf9825317d4f1bf37495c2155d892da8189a7e7f1c"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1c64c632f041a8b6e2549fd45130ce035422eef30fee335059ca55a07deda6ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1c64c632f041a8b6e2549fd45130ce035422eef30fee335059ca55a07deda6ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1c64c632f041a8b6e2549fd45130ce035422eef30fee335059ca55a07deda6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1c64c632f041a8b6e2549fd45130ce035422eef30fee335059ca55a07deda6ac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d822d795e0fe5cf75bda10e518d9be9bbc2338040260a9b79d5481566370e069"
    sha256 cellar: :any,                 x86_64_linux:      "f0d688a0bf57bb21cc0bd1d011c941207f4e7ff94d2161929b68b9b994c5d29c"
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
