class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "16b155bfe1b9109d6c3d368c66a1748b9f0d9ad7ea95ec8cc285f6267aaa0835"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1a9fe034a4a628fd9fe17c6047b2aa019a67a7dcddd294fbd8f24645e01c16b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1a9fe034a4a628fd9fe17c6047b2aa019a67a7dcddd294fbd8f24645e01c16b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1a9fe034a4a628fd9fe17c6047b2aa019a67a7dcddd294fbd8f24645e01c16b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a118939d374d14aff139393f4db631ab7bc5d582521755f46077f0057279b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "451f32054f96a8f6d940ad1be92d38038ee85664228a1467fcc1f4c09df416ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "24855a7b3a29274685ed6105c281d58db39815a6871ecb3125f465e6971af50f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/betterleaks/betterleaks/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"betterleaks", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/betterleaks --version")

    (testpath/"betterleaks.toml").write <<~TOML
      title = "test-config"

      [[rules]]
      id = "custom-secret"
      regex = '''SECRET_[A-Z0-9]{8}'''
    TOML

    (testpath/"secrets.txt").write "prefix SECRET_ABC12345 suffix"

    report = testpath/"report.json"
    output = shell_output(
      "#{bin}/betterleaks dir --no-banner --log-level error " \
      "--config #{testpath}/betterleaks.toml " \
      "--report-format json --report-path #{report} #{testpath}/secrets.txt 2>&1",
      1,
    )
    assert_empty output

    findings = JSON.parse(report.read)
    assert_equal 1, findings.length
    assert_equal "custom-secret", findings.first["RuleID"]
  end
end
