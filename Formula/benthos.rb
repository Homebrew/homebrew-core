class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.36.0.tar.gz"
  sha256 "3b8b3608d97a9e8e58bedf3a91f31c6141d490ebbac445358cf27d1118d27d97"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4280bb501aad44f6c6b10085f3d02d332634add6591945a7fbe2f71d06308767" => :big_sur
    sha256 "a0083686cf1075499fdeea14ce5fc92bbb151c474e08b868c7d3eb4c13f86020" => :catalina
    sha256 "5fc67b8df86ebb14b35837564bb0c7d4d1701026c1e9e1ec9ee00a2134d7b73b" => :mojave
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
