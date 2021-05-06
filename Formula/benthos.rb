class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.46.0.tar.gz"
  sha256 "5444fe6f879a8780c983fabef65fbc7432198c4fe45bbc2ae448475045d56b96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8865636d77287d82bb7db3b1cb6bc73341dea7234e86e11938464b488fb74af5"
    sha256 cellar: :any_skip_relocation, big_sur:       "8520475c98be156fde31698a4b5e9aa5c94233b6e7f252aad41ed8ca70b7ab43"
    sha256 cellar: :any_skip_relocation, catalina:      "628ad1f62d4fb14649e22d4c7861b5960ccb417cb0b2465763a37ee5f4a7ece3"
    sha256 cellar: :any_skip_relocation, mojave:        "a4a85273fd690de32ba1e9a0d03edc30f5d98b946fe2f0c84eb73db513a6ef3f"
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
