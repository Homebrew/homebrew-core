class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.31.0.tar.gz"
  sha256 "0bdffe470ce7689924365af12de5f7fdc6f6ae3e0bb1980f3279f9c8c0e1b462"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d0dd5f807ee23eeea877e3ed617eb2ecf4cc8fec57b99b582cf2ba76a467434" => :catalina
    sha256 "bbd1027c05fa974b3bf7a75c11aad39eb2c67e391d6ec841d36734e9236c6d82" => :mojave
    sha256 "478fbc1d473018241213aebacbe7276ca5d9d18b12b820bdc04d795ef7fccfcf" => :high_sierra
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
