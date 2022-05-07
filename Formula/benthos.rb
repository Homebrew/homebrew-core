class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.0.0.tar.gz"
  sha256 "51e5bfb710a2e482df71c051899510191f4076776d5cd4dba08834837d957ca4"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2fee406d14cd3e8b3e78ca95acfc73c7ff0b6cceca2384817602f6e0effb85b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34a2d72ff883732b8cb87eef183edda87387ead728379aa08109c7a01b6f9e0b"
    sha256 cellar: :any_skip_relocation, monterey:       "033597d7a79de364cc7ed35ee17f5b38741624fa3c7a764c2e076c87585dc7a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ac7aede7de15c1740cbfe4c62e90dc1b1b5ef85d61de2bae405260211e47f8d"
    sha256 cellar: :any_skip_relocation, catalina:       "4a7a4cbeecd8d1830953447a8e246fdaf01dcabfb181ef1f576c1b656e3868d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6571a773a8b57ff604f72f073e493cca7ef6ea113a99f7ea959a69ada704166"
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
