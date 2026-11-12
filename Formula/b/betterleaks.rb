class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a2ef12e63d0218b99bab1aa1a5767fc8395d6e3d33c537a30d1f13c7bae0f5c9"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18d62173e6a4a29180d6e475a4daa8ed34146a8dd0043d2ce12c5fa06f9a8fd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "18d62173e6a4a29180d6e475a4daa8ed34146a8dd0043d2ce12c5fa06f9a8fd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "18d62173e6a4a29180d6e475a4daa8ed34146a8dd0043d2ce12c5fa06f9a8fd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9bab820406684d80b6ae0493efe4a25582eb6faae7d2fe05d4863dc862d4296e"
    sha256 cellar: :any,                 x86_64_linux:      "f4c5d5466f1c1aac1932c1621a0f37e672640fde298286ff7e71f6ac01e5bdbc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/betterleaks/betterleaks/version.Version=#{version}"
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
