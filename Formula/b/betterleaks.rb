class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "1014a8213fe6d2375a09231c7243ada5f59097f1f766307bdef0d566820c480b"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8709c6ba0663a54d8b1ce38dba47697b5adfcc5ea09450d696e2f5f6ec03d8e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8709c6ba0663a54d8b1ce38dba47697b5adfcc5ea09450d696e2f5f6ec03d8e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8709c6ba0663a54d8b1ce38dba47697b5adfcc5ea09450d696e2f5f6ec03d8e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "de18e45bee78b702c12a559c3af94d7d46b88b4d003dfef83a0cdb3259cf03fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa9408facb5e97674cff9a9eba016b45f42a47a58e3b8a61622987a1ed3763a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d0e71403b228a87e580e9a8ad326d267d8bab49a89a742ac0235fa5a798330f"
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
