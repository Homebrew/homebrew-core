class Bento < Formula
  desc "Fancy stream processing made operationally mundane"
  homepage "https://warpstreamlabs.github.io/bento/"
  url "https://github.com/warpstreamlabs/bento/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "fb9198556a919a48961d8c2eb8774bb426bdcc882042ba65637d32cb75d82ba7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "590ecc3bfcd08ce0e3b535cc2cf2299b290e5a0a13cd3cbb2d791160a1e53298"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9dad4d3f6119f4289ead9590dbe0487ebcf98610f8f780300e1f3e721a3d76a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c717903131dc63ebcd03b189653801c632fbf35104fa5f174703360bc227cf98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "503967166118232759e64b4f60c12718e1ee5f3b8322ea821311d3eb3504ac86"
    sha256 cellar: :any,                 x86_64_linux:      "24961fce830f2c3fc04bc1c33a170fe270fa2237087199d1b14e8c7b2729ed08"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/warpstreamlabs/bento/internal/cli.Version=#{version} -X main.Version=#{version}"
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

    assert_match "FOOBAR", pipe_output("#{bin}/bento -c #{testpath}/config.yaml", "foobar", 0)
  end
end
