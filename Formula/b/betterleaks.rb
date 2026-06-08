class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "ddebea272658c703c8ca9b3096f3e98eedb1495fdca1159f350e10e25d11bc9f"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa2724108d55020f962113c9dc3a1681e5a0b9f0c2e88bea36736f94bf5ee9a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa2724108d55020f962113c9dc3a1681e5a0b9f0c2e88bea36736f94bf5ee9a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa2724108d55020f962113c9dc3a1681e5a0b9f0c2e88bea36736f94bf5ee9a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e623be51910d9d60388ad86fd1d3f8a57d6eda732410a7c40521a53eab0767b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e7f9df39eaa2c8ab6b1b6c1486170379fbdf92eba5b0d4dd724fc41658bd6e5"
    sha256 cellar: :any,                 x86_64_linux:  "8d0060004263c869e8fbf2e11d5b200ec7ba0cae7b1ec43600c0c240f3bf2663"
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
