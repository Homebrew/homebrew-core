class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.13.0.tar.gz"
  sha256 "bf6b990b6e6cf1538b71591e3b74dcf2dfecfeb6bf860d1cc68322651ecba48d"

  bottle do
    cellar :any_skip_relocation
    sha256 "69305f44327522481627d9b201197ada57e11dd14915c014f910aa53571c2a1d" => :catalina
    sha256 "9f1e8ac7a384240aa89f9d2fc214fc055f7c80c32f6f471bd94e87291fd156e5" => :mojave
    sha256 "fdc8610ce357e8bbfa31614db80f61acdbedae708b5bf5b7fb31f7aab0f796b8" => :high_sierra
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
