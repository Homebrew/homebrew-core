class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.34.0.tar.gz"
  sha256 "a5d0d747a6d903b2fc21c1051d007384cef373356d2babeba752416a9d170846"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a950d8a9c2c3f6b26d1f8ed9a6198b266c5615f4958793b62e24b39cf25d6c25" => :big_sur
    sha256 "e162573ee90a612ea79caf3d6a16981650b5b43c44c4ba80c87902382853f671" => :catalina
    sha256 "32c934c830e345353f1d96605bf1d25095042e7882c14389cd4b6718013a7080" => :mojave
    sha256 "182198a4312d4ade02a1f6f5d26ac88b0d2337a8f1625ab1590d550e574edf7a" => :high_sierra
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
