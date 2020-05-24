class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.15.0.tar.gz"
  sha256 "adbc882977f45c762b9eab4a4f7b39c8cb3511b38cfa0e15427dc99bed482a66"

  bottle do
    cellar :any_skip_relocation
    sha256 "7f8152e7ca86b2d93b55ae1020caa646a23f6d8ec447a7c571ba5df73c2a9e62" => :catalina
    sha256 "de9186a5bcc1c58e9a835d13e66adaad9ac2cab4e30568ff73ada8c7d535284f" => :mojave
    sha256 "4d6ff298feb1f09e1399c0af1c8532a62e4b161519b91c9080d532215d1801af" => :high_sierra
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
