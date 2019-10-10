class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.2.0.tar.gz"
  sha256 "946bbfe469d88901c8314a42b2b7ea7b243f2faebbcdd55fb94ee151e57d00f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "1179f411bc540fcfa1f907744422dc55edc0c10f601f643ad7a4454fd487d4c7" => :catalina
    sha256 "7e906ab3321f30500f68d4cc5146af401a91b2c4ccb34a1f3648b73ac58eadae" => :mojave
    sha256 "3720a53f3639b6ac10262bd2c50e8572e44a85a64ae3841ddc37e49ef4e5a935" => :high_sierra
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
