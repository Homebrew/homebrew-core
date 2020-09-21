class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.29.0.tar.gz"
  sha256 "da117db9c92ebc6c30b41440fbeaba4f7fbfa740e0d8be185ad2c2298ce8f6af"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c738b0698cd768f0b706c8ac3ffac3f59023d2d0b9e224f52bdade831a3d7817" => :catalina
    sha256 "8cd6fd35e3a6d790ae54af4d4a3dbd39b1b4af670b902dea2b7f816dbbc570a1" => :mojave
    sha256 "140a6fa212677b67550513e17513617a80ffbe9ed6f344c788f66951a249a76d" => :high_sierra
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
