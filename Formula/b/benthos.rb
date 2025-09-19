class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.56.0.tar.gz"
  sha256 "4e3e78edb636be901268bcface1ff551dd7850b7a3dc6c47b61a1ecbe0c549ed"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caea9d898f02bdb4119d2e9cec57145bee0e119b1efc240dcb837299cda04a6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caea9d898f02bdb4119d2e9cec57145bee0e119b1efc240dcb837299cda04a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caea9d898f02bdb4119d2e9cec57145bee0e119b1efc240dcb837299cda04a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c67f513e671f36a8d02e3658513c7012b79d0a225de1c1ad8dc8a42fb325aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abfd115e5b73ca81c8b254ca426620e84e9d2aa36c5f96c2920c73e81ca5641f"
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
