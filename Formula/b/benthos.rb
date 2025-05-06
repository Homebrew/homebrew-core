class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.50.0.tar.gz"
  sha256 "66006425c6f45a3b34251a2e4d88fb77058cdd9c490b93d83faa1e2b38d5357c"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "276285c2319a693c806b417bdbf643ece58878623a42d6270c5dd5d38efdc3a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "276285c2319a693c806b417bdbf643ece58878623a42d6270c5dd5d38efdc3a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "276285c2319a693c806b417bdbf643ece58878623a42d6270c5dd5d38efdc3a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5f54e27c006b635249025a761d2c719f554ab04479004b67fdc9b7eabc705ad"
    sha256 cellar: :any_skip_relocation, ventura:       "d5f54e27c006b635249025a761d2c719f554ab04479004b67fdc9b7eabc705ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef365a0cb1ea4e964f43870e451cd374792a025e0ad5de45ddf37e96a90a3b1"
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
