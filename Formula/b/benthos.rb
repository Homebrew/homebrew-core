class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.76.0.tar.gz"
  sha256 "cdae7ec4993ab38e905f0fbf3edc80676ef8cf97f7bf3f79990b0532cf4523f6"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b3c1b8ea2a295c8cc274c8b537f11538f704bb975b41b4ed962e8b1fa383f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b3c1b8ea2a295c8cc274c8b537f11538f704bb975b41b4ed962e8b1fa383f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b3c1b8ea2a295c8cc274c8b537f11538f704bb975b41b4ed962e8b1fa383f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2edf87999c98cfe91545624facecb4b48d66156a7a9b1170fb31a6f36deabc47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "445ab0bce25c43817ead8cda8757d74234ff2c64465c7dc68783040b16fb1cbd"
    sha256 cellar: :any,                 x86_64_linux:  "bf5526edef5026384cf8c005fbf15355cf56fe765e48ae483878aa4ec5a9d055"
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
