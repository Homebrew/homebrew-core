class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.73.0.tar.gz"
  sha256 "bd445e9edc0b7173a447d56396eaf3c6e0cb42c2b412af0109a180bbba942661"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a89262e7ecfb050b2175677bbeffe59b83f56f66666a5303be8ba20b361dda3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a89262e7ecfb050b2175677bbeffe59b83f56f66666a5303be8ba20b361dda3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a89262e7ecfb050b2175677bbeffe59b83f56f66666a5303be8ba20b361dda3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b44b207ae865fe7ff2777ab079957b9ce42438f41f74a04b3db4fe22974491f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9bbf5cdaaea0c0682eb520b932a525852373278b2c7145fc01bc939fb0b8dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4574f37bb8c71fb9ad1941c8b5738b2a728340738dcd0d12752cdcbd3edca88"
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
