class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "37d077a82e71add680f659b24f67dbd304b87254fe144080457208cd65b4b970"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0f8c674818a2be1a43212b6f420b4f1506e77d8773f2cc1d18b742e9727993f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0f8c674818a2be1a43212b6f420b4f1506e77d8773f2cc1d18b742e9727993f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f8c674818a2be1a43212b6f420b4f1506e77d8773f2cc1d18b742e9727993f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c10ffd43034474e9c04420003ebdb8affb8a91eddecc4b700063c54bf0167aa7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c76e694d625df3f6b9cfaa835df443f56a83c236adf7375b5a98cf2c62aab34a"
    sha256 cellar: :any,                 x86_64_linux:  "e556b9c6bb7864af3c4c5053e5e4733135533a8489b6661aa7526ae187e7da30"
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
