class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://www.benthos.dev"
  url "https://github.com/benthosdev/benthos/archive/v4.13.0.tar.gz"
  sha256 "de4b164806b88addfd0126e4c1be3c76b8b0a64fd11f12fa6c351470ea2d733a"
  license "MIT"
  head "https://github.com/benthosdev/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aab8ac0a13550cf9df0c3ce6e41ae3f89cbb9c0dff42c7d61d8696046dd0d8ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf861769784b82f36cb54991b29d17bfa29abaa0533a31fb185db70c65624ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "180938c66bd8f41cae4ae4620f36ed1c2ba67f3ce7cde10e414c32d26f25fbe9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6237bf9e3df42e237117d99d178f779f3c2b1bd9385088cd1dcbdc417381d42"
    sha256 cellar: :any_skip_relocation, monterey:       "ed86f8b6f4646fda003fc7de74a863c99cb72c6fa2a0abb53b4f7b38e0dfe996"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e86818f1d11fe715554009ad36f84d06b45c17c4d093908dc99a5f66ca1a82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7253e9200c6272addf328364a419c68ffa76371c578f4ffd56234ddc3b20edbf"
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
