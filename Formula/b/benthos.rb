class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.63.1.tar.gz"
  sha256 "ad49d43238e2d457f563aad1c6aa78cae484895ce2b77f533d43fa65b99a3bda"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5ab1b4d8f0fcac0758f05f8ca21949e849a7cc0c5099f127adb29495285414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5ab1b4d8f0fcac0758f05f8ca21949e849a7cc0c5099f127adb29495285414"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d5ab1b4d8f0fcac0758f05f8ca21949e849a7cc0c5099f127adb29495285414"
    sha256 cellar: :any_skip_relocation, sonoma:        "600ae2b97ade090f66a07ea51d43707c966b0139f03437ef7e3ecf2d6a018313"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df144f88a3f4f43a6c00e487a15090e1fa836e6a197bcc49cc226851dab9d831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ddebb14f8ea8dece56c0e184745a13c4afcc6a06d7b3c142d4ac950858e9b0c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
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
