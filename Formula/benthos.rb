class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.49.0.tar.gz"
  sha256 "520f1e6552b5343127c87f1d0e90636ffb3973b05fedc116e48260703aa54ded"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0f1113121be70c0e1ac997896d00da2e04e47cf15314891755d0f521de4b5ad"
    sha256 cellar: :any_skip_relocation, big_sur:       "8af7487e979baaba3611ebf580f5f2cbfe2d3300abf7bb13efc1603c510134c2"
    sha256 cellar: :any_skip_relocation, catalina:      "88ddb4cebd227b224dd5c52c4035f3b1f5bd73faf750c54fa353238e9dd26c89"
    sha256 cellar: :any_skip_relocation, mojave:        "3450e7d515abf8533f34bfad54473202e4be4ff9d1a453f2ed477f2f65ebb6b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "235aebda047ca7a8c0eb64bc33dbd29ee500c56c12c75917fd6d34e5d4560c9c"
  end

  depends_on "go" => :build

  def install
    system "make", "VERSION=#{version}"
    bin.install "target/bin/benthos"
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
        type: file
        file:
          path: ./sample.txt
      pipeline:
        threads: 1
        processors:
         - type: decode
           decode:
             scheme: base64
      output:
        type: stdout
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
