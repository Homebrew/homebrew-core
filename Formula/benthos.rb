class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.41.1.tar.gz"
  sha256 "17021798cde346a671bf58f91abb759252d8d11e4d680294dcfdc1f3b1228b1a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6fde14052119d03663d25215f4506d24ffdac77e5fde52e725c2c916e19b5ae"
    sha256 cellar: :any_skip_relocation, big_sur:       "42f396262a8e7742166df45154dbc17ad844f3961f8adb323eb64c07d1091157"
    sha256 cellar: :any_skip_relocation, catalina:      "209702d9e7b10ba46ca8b4652ca3a3311543352a50fd806fa873e39e3fcd2040"
    sha256 cellar: :any_skip_relocation, mojave:        "6aaaa32f0aaf3afeb8a5e2fd612fa26333e42dd7f343142471e0822e797187b8"
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
