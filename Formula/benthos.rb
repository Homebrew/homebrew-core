class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.26.0.tar.gz"
  sha256 "bc73537045ff19b0d91918b89fd5f4edd610f55061ad3e01e350c7dc5397f4cc"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "af4bfa9edbcf494ca7bd2706fb69b1b9f782a9f53387f284c39f7c2102632b4d" => :catalina
    sha256 "2ad255e7b7944122e50c3ab10fd35fce81991ddbbb3c4b6d9ceca8269d8d4fe6" => :mojave
    sha256 "b011996c0c1fa2b87afbb7651883a3df2c939c83754b42761f3a6efce14bd33b" => :high_sierra
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
