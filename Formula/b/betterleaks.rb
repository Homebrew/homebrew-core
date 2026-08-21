class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "eaaee7fca6342d68fc23d2bc8ebdd5446b4c3d94674bfdbae53110327d1d8591"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e22caac9e1e60675dbb53f66d6ad240ba9eb59c44499aa675df02ee0dc294434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e22caac9e1e60675dbb53f66d6ad240ba9eb59c44499aa675df02ee0dc294434"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e22caac9e1e60675dbb53f66d6ad240ba9eb59c44499aa675df02ee0dc294434"
    sha256 cellar: :any_skip_relocation, sonoma:        "753a5a0a89790cd8bba03a5467997c827d298b5c1cb5c9f9ebaa4f88148d7d51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "173406088967a29a8a357df353e83e9c02e09820a09303fec4c6cf7f2cdbad5d"
    sha256 cellar: :any,                 x86_64_linux:  "b1afbc548371322d80273f863e5d0ca0ebd2f6577ea6a2a28d30d93397d4c74a"
  end

  depends_on "go" => :build

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
