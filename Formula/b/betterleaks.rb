class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "1889be5033c4de90694a0e7fe4e5d21e53c7f779bea0405d309f28db5de673b3"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb03dba8d08785b64704076585c0eed7756e173dcd85a0e844292817d908bdd5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb03dba8d08785b64704076585c0eed7756e173dcd85a0e844292817d908bdd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb03dba8d08785b64704076585c0eed7756e173dcd85a0e844292817d908bdd5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "83f7406a02fb62c625fd66d459de6cb3e1de3d583b5112f64573d5085969c272"
    sha256 cellar: :any,                 x86_64_linux:      "18e50926602c8e7ad5cdcebef124de4bad1f300a1ff92c6f1fac7c2cd0f6b9da"
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
