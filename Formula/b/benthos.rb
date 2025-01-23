class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.43.0.tar.gz"
  sha256 "68ddddc46d3c71e014f32df2c7c14b357dee2065afc86fec7a76a1e1645217a4"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ebc8e41d7436877dca44f311d06694ca9cf9f22711562775750278fdb7d5dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ebc8e41d7436877dca44f311d06694ca9cf9f22711562775750278fdb7d5dca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ebc8e41d7436877dca44f311d06694ca9cf9f22711562775750278fdb7d5dca"
    sha256 cellar: :any_skip_relocation, sonoma:        "814c2608d010d1f71624b5fbcf553aa5eeca81d44abc0933656dbd4fd1119499"
    sha256 cellar: :any_skip_relocation, ventura:       "814c2608d010d1f71624b5fbcf553aa5eeca81d44abc0933656dbd4fd1119499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7c9ac98e2f9a9f6b3b2614310506e708ec3d35d5d64f8860d9c2bccc2b4dcdc"
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
