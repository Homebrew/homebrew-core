class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "06a0e65ad27089a34aa0ccd7795413df327b3f0dd61b5705f1ea1fc68d726c83"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "420dea5a14c59d2da45087419b653afa3de638c00abcf025049c2ba76ae2a413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bfe6cfdc5bdd868862fb433dd9e9866cedaa7be8b0b5ca68b994e99141f5848a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea4acceed9f143cff38a856176261a32dd3594e2ed6358336b55546e41870ee3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7bde12764a34e6650feaea98f590f30b4cf1b3f0357a14a173c3280bbfd60b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0594acd47c54e91378183ca04ff8d71dcafe00d131e8f5f32c657b36bd9b907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48187bc42887b49f12d3700b6e222773e5e6f939c16782fd471d7b516af9f1c9"
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
