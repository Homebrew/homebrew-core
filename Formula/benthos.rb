class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.4.1.tar.gz"
  sha256 "c91950426883884ec2564196a9fac1bd617c990915a745787796c2c3bd936d3f"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc42783aae3cb8ce22ca90a61f1bed411f4e6ae30f603507ff84d4c54054806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "599464785290b05b860fccc3c4ef43d6ba8a532ac086f18753f3efd4401b70ef"
    sha256 cellar: :any_skip_relocation, monterey:       "b43df153be63c8fae299bdde52c42f5dbd8da8351884085fa8f32ef7e371c513"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d979f9faca05a8b109df61474ba49d6fe22863d5583c07c311bbf41374af18"
    sha256 cellar: :any_skip_relocation, catalina:       "9ddd9d83656a3c603743f247e1fa544ad991b0ac27a9a6965d308a5a07ae23a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c760314764874b85bbd54695cf06bb0b45053377d2a886b7b000cb8d5529cf"
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
