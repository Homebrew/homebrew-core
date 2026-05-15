class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://github.com/betterleaks/betterleaks"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2a3d4323e6e2256bafb92b500f1cceefd0a93047a94994931f782b940223cd3d"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "057215812d24fef1591b161631b96d225cb5b959b35fa7881099a4a40f9b1589"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "057215812d24fef1591b161631b96d225cb5b959b35fa7881099a4a40f9b1589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "057215812d24fef1591b161631b96d225cb5b959b35fa7881099a4a40f9b1589"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f4ca67daaffd55842b18a105b25d7d48ea2313042f57ac30b38f7bfde8ff5e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f8bf5a88918c54a15d47f7cefe3c69566ee81e253f1edf1f1528befee4a28d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c67dcebcd3b80c66e471c789b3a271afbf922919017fe939299c88520b3319ff"
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
