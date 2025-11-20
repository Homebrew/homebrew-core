class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.60.0.tar.gz"
  sha256 "23ee60373bcf082d362dbc6bf3bd70cc250c1d780bf5d3975f2bde79250edbb0"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4298ea9bac522c0fd4cd6ce6ecb3281aa5b4d4425428ed5abd2bc0c61b80282"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4298ea9bac522c0fd4cd6ce6ecb3281aa5b4d4425428ed5abd2bc0c61b80282"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4298ea9bac522c0fd4cd6ce6ecb3281aa5b4d4425428ed5abd2bc0c61b80282"
    sha256 cellar: :any_skip_relocation, sonoma:        "db96d457ef0f3fa972a7780fbd9641cc55d8138d01eea5e89d6a7364ebd37d22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fe713379df71dff231df9efd32251afb29d1301257324e1ce29c58f45958f1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03c80918ad6a38d146a4abdb42dd7dc21577aa382881072f5f7f218396cde81e"
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
