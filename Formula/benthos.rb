class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.38.0.tar.gz"
  sha256 "6f881e606b87cc1fb6f1a409b3ee3ec91a4afccdb847a05656b6540632904879"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec26c538b83c31bd6da3e3f7f5071f5799240210d5f0da85f02b0c9ad1a66bb0" => :big_sur
    sha256 "c4ac5d7a2cd9c37b956769170035fae130029b3407031c00a2ee2ed94ab3e5dc" => :arm64_big_sur
    sha256 "5d9de3e50333e761654176c114ed84a9ddd951b687b3c90787235f0bd4251d16" => :catalina
    sha256 "207d3bfb5db760e6d8db2cb08962554f538f44433f795d6dce84c6d7d44c5599" => :mojave
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
