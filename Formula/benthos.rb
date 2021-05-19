class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.46.1.tar.gz"
  sha256 "86d7d03780cec76ba51f0cfdd8c4844ddf154c2e019fbe9bf38394b4693425b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0106c653d2392aa558491a640ec64adac006424887d052af5f69c393790fa3de"
    sha256 cellar: :any_skip_relocation, big_sur:       "94565d3996a83117317d27024f571a2d175c32b0fcb28ef2a4f2c76f826d0ed4"
    sha256 cellar: :any_skip_relocation, catalina:      "d9c7c2113b9692c5de5d0ccc7ffe2c0601ab379c97d1aa74837fca879b3b49c3"
    sha256 cellar: :any_skip_relocation, mojave:        "671c4518f3766964515978eef4b8415fa6b0f42380569cd2f5aa0c124a94ab19"
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
