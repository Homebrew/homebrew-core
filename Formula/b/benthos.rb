class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.39.0.tar.gz"
  sha256 "a8c79c5fa98a48f133b1100927c02c5c10f0410a618ec96336ea95e73d306c7b"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c3fc432a913f4ba9b40f901b1458d3b7d89806d6293fa5dc2dd2b0d40585223"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c3fc432a913f4ba9b40f901b1458d3b7d89806d6293fa5dc2dd2b0d40585223"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c3fc432a913f4ba9b40f901b1458d3b7d89806d6293fa5dc2dd2b0d40585223"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4683d309990116d75924ca0d3de128df3148ecf2799d96fdf328fb8899510c1"
    sha256 cellar: :any_skip_relocation, ventura:       "c4683d309990116d75924ca0d3de128df3148ecf2799d96fdf328fb8899510c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63efe143744d8ba6d0933e637342eee5746193965252dbbb2bd5afd19c4ac3ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~EOS
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
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
