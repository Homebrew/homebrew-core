class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.5.1.tar.gz"
  sha256 "76ca4a920089367f725218c73c024de07a3700584569bbad3c8b870c12d231f1"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "181f22b1f6b2eb21f1991dafa4a232556b73bae7efd51b6934b170b16e863184"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "080d6b836db6b1c31e8ebb5eb03405c5937b38f7aaefee282984cab2e3e73fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "ea34b12c0527da7890347f3e4ff786596d8db5839b33df9d7be6ee09446f5f1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f700784e8bb69776f5de6137d3fbdfad3e07fc27ee157874d316d13d48a4d3de"
    sha256 cellar: :any_skip_relocation, catalina:       "3dfd3cbfd452aaf0c74eb075f780f753fccfacd32ff1a8e6396d3b066e66d226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d7cbe6c3b41d4e98103d2a92b97f05c553db1e5e6463a4b5c109c53272e5b7d"
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
