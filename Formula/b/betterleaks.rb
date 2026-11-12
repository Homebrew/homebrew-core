class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.10.1.tar.gz"
  sha256 "a2ef12e63d0218b99bab1aa1a5767fc8395d6e3d33c537a30d1f13c7bae0f5c9"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "69e4f80c2258b775ab2f8b67eafd954c19679889c495cef28221386625a56ce4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69e4f80c2258b775ab2f8b67eafd954c19679889c495cef28221386625a56ce4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "69e4f80c2258b775ab2f8b67eafd954c19679889c495cef28221386625a56ce4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c8844bee300a851ce3b256671b358630ad0ffe317054e94854002c8058308442"
    sha256 cellar: :any,                 x86_64_linux:      "3931a1b6b5491e5dcde19f8f04a47ec72ed67d10e9a0e8bc15c8ffd55805d6fe"
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
