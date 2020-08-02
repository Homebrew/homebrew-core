class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.24.0.tar.gz"
  sha256 "a945d4b5eca19453d09ba89e8f0cefb6a0e3e1141d46cc15ae49b9c1b2b2b571"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9796a7003050bc4f2ebb07e4b10f84b3dac4cd2ab8b4a77c7f5b01d4821cb869" => :catalina
    sha256 "02cd1f129608bc4f608c9bee3316bbf7b4ca10b7431beda95a9f13843293b946" => :mojave
    sha256 "5aa55b68f0138270ad7679dce9392fb0d053c0275f729c91faee2daadcc79b37" => :high_sierra
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
