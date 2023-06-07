class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.16.0.tar.gz"
  sha256 "1a7d2cbdc73f045617ecb5a72b2bdf373249248ea2b01bc8f3816e54326067ba"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c656fa29e1cb71f8b12eed47d0b6bb10b3eff2f78ba30c0e7e7f3195469cd86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44510e956bfaa10c0efdafe6b37ffbb051b6b37257bcfbbd433e03e16d314119"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1a17669a35963eab5f662a1550d1f4d46ff8aae16ca8d2f3d3fb9c002d7363"
    sha256 cellar: :any_skip_relocation, ventura:        "c700a4c686f3637f4bff31ce2d029fbde7db3875e98595033925662c62dff159"
    sha256 cellar: :any_skip_relocation, monterey:       "e9795e1e0fb4dd012d807b4dfadbf6b7c68b1a5e72d027e9ece4c064378ddb84"
    sha256 cellar: :any_skip_relocation, big_sur:        "0804e961b86247fe65995005877e0e961e388f6242755a07390ea9609ed466bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78a7f0d912af7e4213eea0f97d719757b07e691c6f29e34d45b26cd875d38de0"
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
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
