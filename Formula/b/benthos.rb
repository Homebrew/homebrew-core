class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.61.0.tar.gz"
  sha256 "bdda568983617c24bf4c02199e4a4112954b4c3a23ed5e8445cb1ada0d46c303"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fd2746a4a87a24329d1fa50d1117450a0b260189bf9f69b735e769e340c2e97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fd2746a4a87a24329d1fa50d1117450a0b260189bf9f69b735e769e340c2e97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fd2746a4a87a24329d1fa50d1117450a0b260189bf9f69b735e769e340c2e97"
    sha256 cellar: :any_skip_relocation, sonoma:        "24054cf62bfd08f37d95b64aa64f38499f8d5e4e39419228696c2f9b109709f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c01e6256fa6d7b9314112479924c535a1a6e5bf9f496d36b4edb413923facaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c18fae3b5d4bd0cbc3d0eae37527884bab967a211a89611791ac09414fd72806"
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
