class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.20.0.tar.gz"
  sha256 "2765b49c8ea364e9085b5f6b484b21d8bb4b1974715e164a92d543098df6fdd5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "90dc8a58e7b02e75ecb587a639a9f4c246700c87086eadfbb6ea83c8645faeac" => :catalina
    sha256 "ee9dcf0b3820ef7241ddad29fda38114abd3dd3bb8009c81291b3cad08991a0a" => :mojave
    sha256 "aaeb4398e590ae40409e626b79bde87be24527f532178d2e2cffa7bca2f5e83e" => :high_sierra
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
