class Betterleaks < Formula
  desc "Secrets scanner built for configurability and speed"
  homepage "https://betterleaks.com"
  url "https://github.com/betterleaks/betterleaks/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "c5cfa97483b72eed84b8db04cec0b00a4160a926c977acc37aa0adce271fca7c"
  license "MIT"
  head "https://github.com/betterleaks/betterleaks.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c079473c3b46f43ee112e106e1c4ae495946931f8ab5bff8ce6d503bb363495f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c079473c3b46f43ee112e106e1c4ae495946931f8ab5bff8ce6d503bb363495f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c079473c3b46f43ee112e106e1c4ae495946931f8ab5bff8ce6d503bb363495f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cf0ab77501fcdf0e43b5ee3fb1a41c57b1f67032fd1038d1b8094a787e1307b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03499f85a8be347043cd9c95a35a41a2116bf8cf3870b962db43fa91e2ab38fb"
    sha256 cellar: :any,                 x86_64_linux:  "7734fad833f79b83902d41c36f1288dbe8f38f94f8655e37b6b10c544e571b68"
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
