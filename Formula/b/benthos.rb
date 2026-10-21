class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.83.0.tar.gz"
  sha256 "1e8453380769dcd4968f1da9b0249f458c2fe1741954d72e8009204d50054938"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d130a79f2a55f29ecdaf639fd613e52220c08f045892643a7eed2c066264243a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d130a79f2a55f29ecdaf639fd613e52220c08f045892643a7eed2c066264243a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d130a79f2a55f29ecdaf639fd613e52220c08f045892643a7eed2c066264243a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8d49861c44032064c7c9f3a622b34fe6264130eed0e19e833f5637f04d17f7df"
    sha256 cellar: :any,                 x86_64_linux:      "2740717307718d76130dd0743e6026604d8980da3ba1f605db8e04da0a1b7514"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/benthos"
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
