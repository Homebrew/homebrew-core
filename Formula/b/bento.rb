class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "8f152bc371cfa094d71bea73377654dfc388760e7de87d6cda467aa58489f0ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c41cfc816aa81c46323fafb7e28972f5e6353c894ba658f8db08d23847594cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526438ce00e2b5ff8c9588c2ef506e455a95b363855f30321b9892ee3cbcaf68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735b193b056383b1b6cbcc46942cfb6473783746bffa1359dc9fe36e2d8b76b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "18d04bb7a9a7334aaad6fad776f28dc8cc1d70f3197945ec56eef16ef401f8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "461d8bbaa1dfa26228c6bc32a3dcdac32cf8c237f5b463f69af29c2d14b0a864"
    sha256 cellar: :any,                 x86_64_linux:  "fb0e48eafbde1d041963bd1b1e0341482e7b9cce836c5c3fbd2215bf6099d075"
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
