class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.57.0.tar.gz"
  sha256 "719be1a20755970762034dfa8ddbefd38598204992fa9782ddc9de5862405249"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "258fa1f0fe1dd1ccfb868076ebdd8e54388dd0769cd8aff738362c4cd629cbaa"
    sha256 cellar: :any_skip_relocation, big_sur:       "3825412846e2aa3846588e8008e9bab2ad375b4338ff19e9752a9789cae34307"
    sha256 cellar: :any_skip_relocation, catalina:      "91365a38238a6a87c8a8048ea49f0bbe72fcebbd82db915525928d1460abc6d9"
    sha256 cellar: :any_skip_relocation, mojave:        "2392b1b5a94e215b568919ad54345fb7f0362ee3f791d20775d7b679a35b96d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368a20a3e847c18ddb9581533dd3989c89950fbdf01931265f80f82feebba646"
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
