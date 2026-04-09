class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "997babad7e6ac94c61bfd99ffa71869e917029d18d685ae3f316ebe5382a5deb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "877fa6bd17b0b74996a6f9d66948ef6d1436e68bd5d36be319779a8d453ea336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f07c5e9b7e5d7a318a2d58116488647d6046de71c720c7f73167930629ece3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42ad376f5ab79f3b3a94f0a90ce180a2e3731c29a61a7e3311f266a7aca1e08e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2619c89b460464cfc236b8034a544d3ed67c60b52215626aecfe42a2b3cd8924"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af5284bd8cfcb3451930550100c4e31b173e0442d02b6c7c0c5f5bb65d647077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "351bccae4a901bcf284f5e65b91117ccfdc0aa112c281b2b84d3be2e9a0bcfd0"
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
