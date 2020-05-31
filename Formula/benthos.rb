class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.16.0.tar.gz"
  sha256 "54906dd1300ca1dc359ef80376c1375395b1a6a0eba0c3f0f601d08f25eebafd"

  bottle do
    cellar :any_skip_relocation
    sha256 "773f7f9cf3ed9d49c8163e0226d77f393682757d9d7ca5ad33ad22dde2c0724b" => :catalina
    sha256 "ec4ab67d02d4a9ade4301b7af79be0db68c0fc4991a297c56b4202baf8211c06" => :mojave
    sha256 "0fdc6b1f72d416abf4741773041bfda630e1f91bde25579fec2b27165e38dec2" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/Jeffail/benthos"
    src.install buildpath.children
    src.cd do
      system "make", "VERSION=#{version}"
      bin.install "target/bin/benthos"
      prefix.install_metafiles
    end
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
