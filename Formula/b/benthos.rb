class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/refs/tags/v4.21.0.tar.gz"
  sha256 "c9ba9adcda3402b243df58113af1f384053dd6d86afd2aa0200aebb81e0b4deb"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "534b3586619c684b9d9d054a908f6db03c5b5ae9e035394c0f460c6ce7ca8abd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64934a8da625de7d1a6c0a835743d018c720bdf9e4ba9c5bfa658d66ef1d5de6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c32f998ea5981e89d13a27e80e0cf926f34fc4b176afbe18294a9a6731239ff"
    sha256 cellar: :any_skip_relocation, ventura:        "4c500fc29ae7b06f2a59ca480795619e2ad64c7b4593c9712ea2c45dfe51ed64"
    sha256 cellar: :any_skip_relocation, monterey:       "8f654754c0f92ce16ae08357000d36da8a3d8db443202d7ff0442559f8fcdb9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd451763d3d969b45614944ac73c18fb91adb4463351ba854d9cc4e6f6bc7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4372973a0f2bb1eb8dcfe0842fda5299488029c3224276c218c15fa407d2dd9"
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
