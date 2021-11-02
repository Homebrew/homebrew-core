class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/Jeffail/benthos/archive/v3.58.0.tar.gz"
  sha256 "a7a71f3dff5d3b9e3acefe66a553f61b75bbd4ce98fad32a2c4a178bb6d20587"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13091f4eb875655f22dfff295ea58c8ae46f8f60096ac12322a8b1cca5fb3913"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "258fa1f0fe1dd1ccfb868076ebdd8e54388dd0769cd8aff738362c4cd629cbaa"
    sha256 cellar: :any_skip_relocation, monterey:       "c3eae40009f4ee8ec631848ff5cb603e6e648ff62bce265dd5984704a5550ddf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3825412846e2aa3846588e8008e9bab2ad375b4338ff19e9752a9789cae34307"
    sha256 cellar: :any_skip_relocation, catalina:       "91365a38238a6a87c8a8048ea49f0bbe72fcebbd82db915525928d1460abc6d9"
    sha256 cellar: :any_skip_relocation, mojave:         "2392b1b5a94e215b568919ad54345fb7f0362ee3f791d20775d7b679a35b96d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "368a20a3e847c18ddb9581533dd3989c89950fbdf01931265f80f82feebba646"
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
