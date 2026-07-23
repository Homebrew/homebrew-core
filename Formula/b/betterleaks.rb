class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "4a9e5ae8f97dbc62d3d05f97dc94a07c380e804a4fbbc75039f8bce6bda8e156"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f77249430c91453ceeb87712f574b116451045baf883551050de9cb73fbb934"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f77249430c91453ceeb87712f574b116451045baf883551050de9cb73fbb934"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f77249430c91453ceeb87712f574b116451045baf883551050de9cb73fbb934"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf433481bc11cccbd2d0dbbf9555177af94c4c0e3dd5a804690e5d22ce0ebb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0dc429f44bcf6276d883edaaacd80532439cb1cdd39acb3dbcc807938dbe6807"
    sha256 cellar: :any,                 x86_64_linux:  "38d0c2dad96fc68f0500429558139c38dd3dafadc4c857ac2f84db2a18d3a39f"
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
