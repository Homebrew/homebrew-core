class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.47.0.tar.gz"
  sha256 "181ce11242865e35a983448900ce51fc4c2c20ac0914a71b0ebe297a52cfb9be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e379a7ed981d6389b92b78692a0727afd18727afc8b1b5088ffcf1f2da49114c"
    sha256 cellar: :any_skip_relocation, big_sur:       "43aea8dad6601a12708eecbe7026900d6fd3ca21c5d8d295a0a1db6e6230463b"
    sha256 cellar: :any_skip_relocation, catalina:      "0d975473bf423586c7d275288168c4a6b3088d3c1f3fd6e1125d1db18b3e3e20"
    sha256 cellar: :any_skip_relocation, mojave:        "3ab49acd505f8c68972be84dee53dfb3e1721ee84524f75ad8731c6ec31fb892"
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
