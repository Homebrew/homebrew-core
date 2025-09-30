class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.57.0.tar.gz"
  sha256 "7a3f5118329bdf17acd27a42bdc45f95e5abd6c39c1646a7b6d17672b0603ca2"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ac96f9298bb5ab8b9fc208a55580211bb8eaa27fff48b43e70317201a922e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ac96f9298bb5ab8b9fc208a55580211bb8eaa27fff48b43e70317201a922e3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ac96f9298bb5ab8b9fc208a55580211bb8eaa27fff48b43e70317201a922e3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc9bc18d9b3eb78fa2b11f5f97f187716ad82e8f9ab4b1f6246d2ed7c454008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e80ca4135efbf72fba41c01ad9af28b3ef8535fd619b9959b6e3d2ad69568b0"
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
