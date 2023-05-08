class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.15.0.tar.gz"
  sha256 "56abf2f8811dd5e67b591b5b2a9b0ef316be06224c52f3c7d7f68b96f9f16aaf"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7ac02f2311cc0b0e8cfc4aab1ac9968a9e5ec2cf2a942fda94a054c4f761e4d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c86dd6d77e08e74abfd44053147f0c35f3c7fdb105178823b7466fa11bbe34"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "477f8afa229989403b33ba3e0609be787f670bc588762b532a7b850776d31b0d"
    sha256 cellar: :any_skip_relocation, ventura:        "e402c180c51c0f125aed60a58029b72f0296d310ea451d25dc21fa5e08172fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "dbd208440f8ea0760f9f62de89c28f613ad63e9920ca836770fd22e2b84130a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5013014e87941bbd725f393ceb17ade80c41db6570ae28679f59666fb7aae01f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9f55db14553701b48518745c0085654d5e078eada53a87fb6025ba5224776e9"
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
