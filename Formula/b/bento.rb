class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "890b066f9f0e28501c499cdc9b6398177e4d2dee135ce19d8f449485eec40a5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12ee11715f03d8d0dfb8c81aded964999be083196fd9f88653c748991e861b7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73b08d2d2aa5bee9066da5c68af9cf7d6b22cfa046875c900d35a069334c876b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b17756d6eb9ee848e9e675e41f566f0d09da83e0e9f60cb6ad94c5b735082e3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd28f081ec8e8ad59ae115f3096312a59b93214e80591f179d1f8fdfb01403d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5c003ba2b2af74a329d39b4443f77bf49e5447c4dc1db273a3e8c732217c94d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b01448729d2adeed4d520e4351e86192da2ddd3580efe9730ffdf214bcd5b1e"
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
