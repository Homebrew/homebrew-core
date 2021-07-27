class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.51.0.tar.gz"
  sha256 "079a83afbe1b363a38dac50d853028bfb232176f3266111248fb6a592d9e638b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2164ef4f6e278eee3f45915880ba13ebfdbe4e011ede0e37e3151ce97739549d"
    sha256 cellar: :any_skip_relocation, big_sur:       "d6ee2f8389fae2bcd15ba2ea169f5a369a21ab875b8be7300c4084dcceb5b1d0"
    sha256 cellar: :any_skip_relocation, catalina:      "ddea178e13b530cc9d76588ee77f006ce40031754772e980769c5c573fc9db15"
    sha256 cellar: :any_skip_relocation, mojave:        "492d0246224fc0a8f038f08fa8756f3190fc7bf2daea63bb2d53f5e694180080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5bba1f4a2c1c6296ab9383f7e34e2ecfddb037424fc1f5a7ccded53b175227"
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
