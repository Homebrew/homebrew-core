class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.38.0.tar.gz"
  sha256 "6f881e606b87cc1fb6f1a409b3ee3ec91a4afccdb847a05656b6540632904879"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0d4ff9381291f15d0313a9f78f58411ff7d0ec0869a3adbaac3ef43d920bf2a" => :big_sur
    sha256 "01d6aa3f006ec1c2fdfe42c12f31baadf91fe7d71ffaed751024dc51716e37f5" => :arm64_big_sur
    sha256 "eaff6c72cff21bc53bc84c3522b1795e885b10ac82bcf1573bbea4840c47b7be" => :catalina
    sha256 "9d9b9083c8993d23f28cb06b464f6f16ce78e04d0cbbe3f55aa64ec2e7180cd6" => :mojave
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
