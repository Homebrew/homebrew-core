class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.42.0.tar.gz"
  sha256 "78078efe980840999c3c67d386d7b76f2f55cb4c59ed262fc11344f15bc3fd87"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4d0137c6e6bfc042aedf8321a7dad38fe36807f2d58926907f48fc008ee7eac"
    sha256 cellar: :any_skip_relocation, big_sur:       "963d961478c3d5cc80d71bda1b1b298019b60fcd76bf66273c900263d1677e94"
    sha256 cellar: :any_skip_relocation, catalina:      "b1def5cae8ddb66c476b829717c1d2344857a0c58fa7cccbf61c4d8db3b0c620"
    sha256 cellar: :any_skip_relocation, mojave:        "69151aa187f6b9081533cb354aec443310ac4175bb5e96c5e3fa353834a3e1c8"
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
