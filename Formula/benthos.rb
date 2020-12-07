class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.35.0.tar.gz"
  sha256 "c864c6f47efa759ae90828926cc18de5ea9dc355bd34ac5cebf352a41e6ea2c7"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "539cee03ac23301ed43f29cb7df69290d637cf3b76d7e1d3167609a4e6fdfc42" => :big_sur
    sha256 "8b45b3ebe8874b84c064fb8a49a772fd9c5e87739e52e1967f0a79ef46ba8af0" => :catalina
    sha256 "528d287259791e34c4a07e344a13081c684add2371376379590ba84352032e58" => :mojave
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
