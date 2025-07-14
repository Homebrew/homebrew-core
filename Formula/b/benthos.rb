class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.53.1.tar.gz"
  sha256 "b4184411c3d30034f2d4e40311c450dde83b3fe92e9f9139c216ca48b5aec384"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbf164c7ae782bd5a29a939a5d3910123f899b4e5de60dd1c13667b3e6a57e47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbf164c7ae782bd5a29a939a5d3910123f899b4e5de60dd1c13667b3e6a57e47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dbf164c7ae782bd5a29a939a5d3910123f899b4e5de60dd1c13667b3e6a57e47"
    sha256 cellar: :any_skip_relocation, sonoma:        "436de56ebda70bde630b40fa1ad7e6b6d816fbfaaa4a3b396dccb75dc5742183"
    sha256 cellar: :any_skip_relocation, ventura:       "436de56ebda70bde630b40fa1ad7e6b6d816fbfaaa4a3b396dccb75dc5742183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2c5a86bd6e83b4103d38de5c80f8710f5c53f6c4f84faa9e7f69d64e391e495"
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
