class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.44.0.tar.gz"
  sha256 "a1739d4c9b9ac4bb94f88301335ad6079a8ad3bf16ae024183e1118705b6ec65"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f34b9d42a719224c72ca345f9043ce425e05aa6d27d28a51e7b50001764befd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f34b9d42a719224c72ca345f9043ce425e05aa6d27d28a51e7b50001764befd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f34b9d42a719224c72ca345f9043ce425e05aa6d27d28a51e7b50001764befd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbf5fde0a1e20d31f60655a00d61f5703a674fda8d14891daf996b98e284c72e"
    sha256 cellar: :any_skip_relocation, ventura:       "dbf5fde0a1e20d31f60655a00d61f5703a674fda8d14891daf996b98e284c72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a60703ddd890d5bd020bf835ebac8e8f9f104823390cf3ed0eea174bd4e77ffc"
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
