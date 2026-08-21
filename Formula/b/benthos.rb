class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.78.0.tar.gz"
  sha256 "ccba6fdaf6921cd5f1c6dfc7f8cf082a08d10cbb03aaf7181012acdbfb7a9d55"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4ecb41385da506b7885d66e95083f277823bd4789be32fa1d19183800ab09d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4ecb41385da506b7885d66e95083f277823bd4789be32fa1d19183800ab09d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4ecb41385da506b7885d66e95083f277823bd4789be32fa1d19183800ab09d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a032c6d226ede1496fdb5d4e5dcff187c8842785fb288d66a6f0ed43b74a4177"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1637bbe5d0ec654bfb19f6106db9ca801d150060a7c17a55abe4bd6de2163e01"
    sha256 cellar: :any,                 x86_64_linux:  "042132baee29586a63a3e4e50719c6871bbd2ea37780bdcadaa765395fbbbb45"
  end

  depends_on "go" => :build

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
