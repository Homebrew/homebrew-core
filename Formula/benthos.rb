class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.12.0.tar.gz"
  sha256 "ae2e22c2ae096e036f17b6bba5dc89a51e6b23fec88ce1216ead2fb06ca38487"

  bottle do
    cellar :any_skip_relocation
    sha256 "d03c075aaa4466af2392b2c9f49855654eedc6381d4b3ba404e4a8de0776d12a" => :catalina
    sha256 "1a529c326b86c075f3a95e9dc5e3cd0c4960c736235270f01c708f3a2fffa89b" => :mojave
    sha256 "dc05481effbf7e4b05f3cfda297fb35cb6f2ad2d7ef78208f36ce34c05747435" => :high_sierra
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
