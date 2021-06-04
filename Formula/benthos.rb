class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.46.1.tar.gz"
  sha256 "86d7d03780cec76ba51f0cfdd8c4844ddf154c2e019fbe9bf38394b4693425b9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "52428de129a8e0f4e394b885ba0e785e939ef3204997298841806759a7c3d8ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "29287efa00b492290cff5107b8dc36c3382c8ac8a9ad70cded2f70099177793f"
    sha256 cellar: :any_skip_relocation, catalina:      "6fe349fd9b64240d4169b8faed8001d0bddc9119fd94ac338dd4fa73f251ebbe"
    sha256 cellar: :any_skip_relocation, mojave:        "bc480e1b834482844c00aecdbdcee516996f770ed554225a8c153fcbe077f50a"
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
