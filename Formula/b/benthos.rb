class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.69.0.tar.gz"
  sha256 "ca30375bfca540f08a6b9f56d20b5647599b4991d2861862b374a1d167877bf3"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f0750d3df66d06ccdde94bb74d11252f2883d3f63349a2fb08f8d4c9f43a819"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f0750d3df66d06ccdde94bb74d11252f2883d3f63349a2fb08f8d4c9f43a819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f0750d3df66d06ccdde94bb74d11252f2883d3f63349a2fb08f8d4c9f43a819"
    sha256 cellar: :any_skip_relocation, sonoma:        "02579661f6cf5782be73b5a9528b71485c819dba6f71d031f3732c2f4ea2a8a4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ba31eff18d551d8ae15d605e231b5ca5f64dd110e0fe4123f4eb25ca28adaea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "805bba49175a196a2bf62263b86a7a58f3ecfcf0c3c97aec4ebd1fb57e194f21"
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
