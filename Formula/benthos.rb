class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.13.0.tar.gz"
  sha256 "de4b164806b88addfd0126e4c1be3c76b8b0a64fd11f12fa6c351470ea2d733a"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2a115088f24a0fd0124a65a357ee8b73750468fbf95a8adf4578644975cb7c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20c45d76e89f026a989208cb49c5d9e62609631a6cb7233ac57dcb1bbb79a983"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c40d181d2f5a959bf01cbceab454f9625acbd96b02d69f978fcd4445dff35b92"
    sha256 cellar: :any_skip_relocation, ventura:        "fc9f3b6e337299bde1181bdbc52458406c93b77bb960328b0d8778af06d74715"
    sha256 cellar: :any_skip_relocation, monterey:       "41e2eab9622d931fc3e532e108abd05adf2adc4bd52f49e1f23b6e55fe2edf31"
    sha256 cellar: :any_skip_relocation, big_sur:        "4930136b16eaea1da65611ca23becc4813f48f0bbe8286191b78ce8c7c2c0239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "196638a895c1a61834cab40d804cd0adb65d5db89871886bfd9701e6bf5b58a9"
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
        file:
          paths: [ ./sample.txt ]
      pipeline:
        threads: 1
        processors:
         - bloblang: 'root = content().decode("base64")'
      output:
        stdout: {}
    EOS
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
