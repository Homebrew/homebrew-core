class Humanlog < Formula
  desc "Logs for humans to read"
  homepage "https://github.com/humanlogio/humanlog"
  url "https://github.com/humanlogio/humanlog/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "f57cc04582a84cc786ea1a9198ea2866fd269c2ab5a2df4ea6f9998394786186"
  license "Apache-2.0"
  head "https://github.com/humanlogio/humanlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc12c7ec58b20fdfbcb5e198946b3b875469ac8e2ad91a08c7fa293af82a3a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda18317c1e70789fefe613a982d5bd96f11df299d92486c428c4db5e52857a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56fa20267a85d9d8c380f4d86d41bd0b339ec315cc78147db5eaac65718a976e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a2d7565c23aa338dc8bbecf44133f512547b6257f27eec861576a3b6c6ee989"
    sha256 cellar: :any_skip_relocation, ventura:       "d2a93d2ecfebac388d30f98604b21c51288ac249eff2d8419ad2eb688ea7caf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "effaeb40a46d830b4a16ec8d240dee54bd114709898b63529e416abff33a30d3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.versionMajor=#{version.major}
      -X main.versionMinor=#{version.minor}
      -X main.versionPatch=#{version.patch}
      -X main.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/humanlog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/humanlog --version")

    test_input = '{"time":"2024-12-23T12:34:56Z","level":"info","message":"brewtest log"}'
    expected_output = "brewtest log"

    output = pipe_output(bin/"humanlog", test_input)
    assert_match expected_output, output
  end
end
