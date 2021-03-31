class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.43.0.tar.gz"
  sha256 "5e85ba9b4f90424361df3a41c0f5ca7a0a3835d96b784b95958ecaf42dbb1c5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cedb6d60da4a8fd196599e334f884cdad93346770119740fae8d62dcf624cf22"
    sha256 cellar: :any_skip_relocation, big_sur:       "034fd2fec9e8f5ff0e3ec1946fdca0601e8b5d22e5a49536fb0f7c58d274df59"
    sha256 cellar: :any_skip_relocation, catalina:      "68cd2bd48b01b5756f6133ca9b4b7e134bd1b2adfe69ce45127eaea630607253"
    sha256 cellar: :any_skip_relocation, mojave:        "991fda313f2d0180d42b0c6cbf4ed6f71946a0b044092df1a159087988cae508"
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
