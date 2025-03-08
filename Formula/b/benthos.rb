class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.45.0.tar.gz"
  sha256 "0f4103615fadbc2c6182b26316194ce4f24566a45e451c54bf54f5141d1c00e2"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6546f7499024a86442422258dc1c401b144ffb68f7f462532619c5f37460ad4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6546f7499024a86442422258dc1c401b144ffb68f7f462532619c5f37460ad4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6546f7499024a86442422258dc1c401b144ffb68f7f462532619c5f37460ad4"
    sha256 cellar: :any_skip_relocation, sonoma:        "90394bf7187f5f34eb9c63f1274b95eb8dfb1327aea0c1d1b94e9af459204109"
    sha256 cellar: :any_skip_relocation, ventura:       "90394bf7187f5f34eb9c63f1274b95eb8dfb1327aea0c1d1b94e9af459204109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d455098f0a7adb5e26e1b45ff43d2bcdbae202fc802f58d294ecf8d72f51306"
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
