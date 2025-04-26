class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.48.0.tar.gz"
  sha256 "19bdb73c028524f2c52389a3a5144dbb65f807c7bac91197abaf20a421ea5783"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef34a80233e9bddef8908f51ed424c83dda54e27cef77396b414c6a0890887a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef34a80233e9bddef8908f51ed424c83dda54e27cef77396b414c6a0890887a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ef34a80233e9bddef8908f51ed424c83dda54e27cef77396b414c6a0890887a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cf4585c2605673f6cb45f644edf1e969db59dda14f7cd060adf256a118fa740"
    sha256 cellar: :any_skip_relocation, ventura:       "5cf4585c2605673f6cb45f644edf1e969db59dda14f7cd060adf256a118fa740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d37aa2a4ac91e4d149a900f269becb1068be16b2f84a80763d31bb11a61b13"
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
