class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.52.0.tar.gz"
  sha256 "9a9db919569287a7cef2efb7bed990883c62db6694469529439f8e5c34f959b4"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a799c55fa8039592fb4d8c042077f73da05aa00014e4e0cb453fc6f8c767023"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a799c55fa8039592fb4d8c042077f73da05aa00014e4e0cb453fc6f8c767023"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a799c55fa8039592fb4d8c042077f73da05aa00014e4e0cb453fc6f8c767023"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd32808c282d66ec21aa523786fa3957a3c53c1ee1a2a3ad97e6271ba6962370"
    sha256 cellar: :any_skip_relocation, ventura:       "cd32808c282d66ec21aa523786fa3957a3c53c1ee1a2a3ad97e6271ba6962370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af417f9d1515d043c58f7818d8fe9e2bd7c7f263572462b258944e18c0f9dd46"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/benthos"
  end

  test do
    (testpath/"sample.txt").write <<~EOS
      QmVudGhvcyByb2NrcyE=
    EOS

    (testpath/"test_pipeline.yaml").write <<~YAML
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
    YAML
    output = shell_output("#{bin}/benthos -c test_pipeline.yaml")
    assert_match "Benthos rocks!", output.strip
  end
end
