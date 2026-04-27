class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.71.0.tar.gz"
  sha256 "c37a460efd3240180acbaf39fcb1b011be5f1d2866399b6359e62b6dadffaf56"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b93161737f3c01e0188c3e7491f8767da12207786bcf4bddbdd622fa988eab80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b93161737f3c01e0188c3e7491f8767da12207786bcf4bddbdd622fa988eab80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93161737f3c01e0188c3e7491f8767da12207786bcf4bddbdd622fa988eab80"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b4798989de34574212c5357eca534077fccccc5f518148d8c51b059c53f7531"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbea3d92354ef9125152f37ba2e34459831e53cf12d480bb52892dae04482fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35925669007e269e4d3022436d85a77cbb603033a9c2cba5dbf4fb459956a234"
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
