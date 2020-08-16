class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.25.0.tar.gz"
  sha256 "65c458bfba9a115c1898ca00968d24006ae23f033fc6ec7155bd7d18f11cd174"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "f31cf5ddb3b6e9238bbd90469cb8a6fb1982a5e360721336af8025ff56388ad4" => :catalina
    sha256 "7f3668bf74431287595ef50df7555e0a738f32cb3dec64ccf4ced69e342fe4f2" => :mojave
    sha256 "a555adda3aed361acae4e64cea3b9bfef35957942cb9bed7c520bd1ec7b98edd" => :high_sierra
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
