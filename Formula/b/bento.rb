class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "d00a575d90e038d696dfd6140d542f25e760982a239aaefb63265be9930ae1d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3dbf6e2217dc4dd2b6990fc351858bfa68ed775378016184394faa8e6fdaac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6101a4553f0b19b0b6b9246a17755862956d32616d71a46e98aa26f272f143a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a034afaded59464827d9fac60edde5dc0789caa866d5e0df5769bfe05a6fe569"
    sha256 cellar: :any_skip_relocation, sonoma:        "d376ece5a610b7e7a7086694bc6296b1076345db21edad7ad1c8f3fa3e5a9188"
    sha256 cellar: :any_skip_relocation, ventura:       "1adc56a81509575e66b0728335c5a1648d2712e07ea0cb639adff184b5b7530b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "167604f5541969b510a4a2e2d7d51fc4269e32cd8706e731a47b4150f5648c9c"
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
