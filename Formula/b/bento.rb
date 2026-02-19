class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "3acf54b202c250a3a2196f5b8f28788933f8689dc06f07feed7d996aae561182"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be171c78149593a9257c18a5d8f1d24a2a9927982eec1691a31aabb1e08d8e6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13e92a4553a3ba2e09f8db379ad7ee644a62b95f3c8330aa76441f963bd89054"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975ca71bca1bf4e5aae584413dbf419f53473577ed89376c52b532476a27f82e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e25a2614fc802e03d7d303cef2369c00ccc19f7e5e0acb5398399c408cc70f39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9fccb5f9a29c21966bc717aad2ed89ade57ff77b6879abed3620530dea74b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cbde4d718d5951aad9d35b0cc9946f03029e4e9317142e7602bfc0de9d3b714"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w  -X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bento"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bento --version")

    (testpath/"config.yaml").write <<~YAML
      input:
        stdin: {}#{" "}

      pipeline:
        processors:
          - mapping: root = content().uppercase()

      output:
        stdout: {}
    YAML

    output = shell_output("echo foobar | bento -c #{testpath}/config.yaml")
    assert_match "FOOBAR", output
  end
end
