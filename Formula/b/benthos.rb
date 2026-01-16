class Benthos < Formula
  desc "Stream processor for mundane tasks written in Go"
  homepage "https://github.com/redpanda-data/benthos"
  url "https://github.com/redpanda-data/benthos/archive/refs/tags/v4.63.0.tar.gz"
  sha256 "b8ee91fe0936687fce35e4f805da8795f5f1140166d568d15421b3ad4b0cf7a5"
  license "MIT"
  head "https://github.com/redpanda-data/benthos.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86ad73662ff5b45bc10b71307c3e47d2380a9bd9de7b8cea28eceb6de52050f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86ad73662ff5b45bc10b71307c3e47d2380a9bd9de7b8cea28eceb6de52050f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86ad73662ff5b45bc10b71307c3e47d2380a9bd9de7b8cea28eceb6de52050f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b079b30d0cf2675a5e8d17e00dbf7a93a432def58188d8873e936a93a72952ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a49e405accf572080fe13bf3b6cf306b71d99137b253db447d979cd8b1da7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37ac70a2bfe00c88e179d3b64febb3b184f1845f550db501e93e2a7dc24b28af"
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
