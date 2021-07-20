class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.50.0.tar.gz"
  sha256 "1a6dd790bea08826bacf11605d168ff16fe2b69c6892e0695cd54743e0e57d99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e3808fb2d74c726a6c3fae356156c5a906ad1c110ead2b19883b43a5a6c28b6b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ad3c2cb03f0e8d3c39af1831f7751fb7a1504150925eefcff9beb856666d2f0"
    sha256 cellar: :any_skip_relocation, catalina:      "79b004fe2f9d5693a5de6807363df336d1dd89040c205ed175c10699d53ef064"
    sha256 cellar: :any_skip_relocation, mojave:        "995a0e236f0d2855e7322fcf677f3225c2d7a127d0fc620eb2a113e8ebd17650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4955748e646f1552ad8b6309982d51dc37ead0d8c66942ae345ef7eb34d78339"
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
