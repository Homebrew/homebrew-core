class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.11.0.tar.gz"
  sha256 "864023b1152a527b75092317bc468506bbed4f118df03b786ae2999c9706af87"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2dca381f85f5bb049f651787b0eac5ab0282da81c301f55699fea3528799e30" => :catalina
    sha256 "ebc2c56d1e4d96b6f2dab2c3994a62fa70df8e160f6d5a2b93ae414601454c3d" => :mojave
    sha256 "317840cc1ef67e3535845b34067769fc72651eb76f9e0fe07989930545bacd9f" => :high_sierra
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
