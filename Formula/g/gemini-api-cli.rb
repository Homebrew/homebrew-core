class GeminiApiCli < Formula
  desc "CLI for Gemini models, media generation, and managed agents"
  homepage "https://github.com/google-gemini/gemini-api-cli"
  url "https://github.com/google-gemini/gemini-api-cli/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3da223c307b0ca9d5e1d788fb3d195f6a024f9dd5001f1c18529972e4d18a7cc"
  license "Apache-2.0"
  head "https://github.com/google-gemini/gemini-api-cli.git", branch: "main"

  bottle do
    manifest_sha256 "13c40bbc80da3059a7d340d6c193c333c91976952452637c0293a4f2cad3f52f"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0fe38356b9d2217aa9545c94c6a0fe76c46a7d0ffb67876e6cba692f7763bc25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0fe38356b9d2217aa9545c94c6a0fe76c46a7d0ffb67876e6cba692f7763bc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fe38356b9d2217aa9545c94c6a0fe76c46a7d0ffb67876e6cba692f7763bc25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce0a656ac7a2a7d4f696d22d75a89a2395f6c7f34dd31c8e4b348c0d83e99423"
    sha256 cellar: :any,                 x86_64_linux:      "a6c7ccabeedd83227931c1fa5601e8603c7421ba91f40757c8ac186c4ffb4367"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.buildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"gemini-api", ldflags:), "./cmd/gemini-api"

    generate_completions_from_executable(bin/"gemini-api", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gemini-api version")

    ENV["GEMINI_API_KEY"] = "test-key"
    ENV["GEMINI_NO_KEYRING"] = "1"
    output = shell_output("#{bin}/gemini-api generate 'Hello from Homebrew' --dry-run --output-format json")
    json = JSON.parse(output)
    assert json["dry_run"]
    assert_equal "POST", json.dig("request", "method")
    assert_equal "Hello from Homebrew", json.dig("request", "body", "input")
  end
end
