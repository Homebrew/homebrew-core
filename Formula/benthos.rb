class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.1.1.tar.gz"
  sha256 "7ba194ba4b38355f454cd70c69b4163bead47df70264515f1de7c29882e468b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee04873009e3554862892dea9d7a98169949771bf547c3cd34a0067d00d09f41" => :mojave
    sha256 "fc5cfdb772267e57f86d2d58d4625cb79ed02f382762b6af93f736a610617965" => :high_sierra
    sha256 "beb648e77b86db02cceaf7ac4e0a8a96cbe36cfc04db3205a0dda2157dacad97" => :sierra
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
