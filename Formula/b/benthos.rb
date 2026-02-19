class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.65.0.tar.gz"
  sha256 "2247d6b1718fbcfc8c75248becde0919548e9df03debc6acb49e34b336b498ae"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78657b376ed93a37e9dd6212a076a1e5a171e39faf7f4cf46a31f25667056e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78657b376ed93a37e9dd6212a076a1e5a171e39faf7f4cf46a31f25667056e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78657b376ed93a37e9dd6212a076a1e5a171e39faf7f4cf46a31f25667056e7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "94ddb93e89348a41cef24568d6c89e0367f56200a2f3d1508c62ff278aedd6df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72bd974593684125fb6729fe11686c59ff6d92352679902cfab8bb489d08a17c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a1c53cb6dffd5fd30059c7375ec36c1e68fff42fab7811a607f3b8e0958d01"
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
