class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.53.0.tar.gz"
  sha256 "abcd431f15b36daf900287d9e5c8dc62eaa4526862b07dd4a597b868377efb47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bc056766bb49b3febe570fcfa12598b4df8ce727d1ed40f54a57a9fe846352cb"
    sha256 cellar: :any_skip_relocation, big_sur:       "541010f29500bbb4524f94b933b4ba178e23420014de76077d81d7dd2163414b"
    sha256 cellar: :any_skip_relocation, catalina:      "5dcd2ada93e6ee449f0cc781a49a591e7403df3d23522c0def9fa47a2633c239"
    sha256 cellar: :any_skip_relocation, mojave:        "08005503717dfb1f4cf5b3d0181a35a19d720ee5893d7ef91d40c48d41644669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c18913927a681bdfdc8083a5e08b5379a4329bb53d90c19c6f8b243b2729191"
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
