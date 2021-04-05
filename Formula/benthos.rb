class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.43.1.tar.gz"
  sha256 "24e4f09d1ef9eca48c7267365764a6794bf9c1573389f55792eba58cb40b9e83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8539d5d5377497481dbc62facdd530e39fbc343796c4d248163332db67cb369b"
    sha256 cellar: :any_skip_relocation, big_sur:       "d5b89a656e9e54a0b43e0a763cbc25d192185dcbbc5b9cd889593bb6089f2afc"
    sha256 cellar: :any_skip_relocation, catalina:      "e6ad322a186c75ee6c34c5b96cc2c23182a787bb73c324785df73b12b2787566"
    sha256 cellar: :any_skip_relocation, mojave:        "cefa8343113d3f55522bb637778533b93cb9a8f2aad1999fbe98f0eff2404036"
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
