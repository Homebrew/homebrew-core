class Cymbal < Formula
  desc "Language-agnostic code navigation CLI powered by tree-sitter"
  homepage "https://github.com/1broseidon/cymbal"
  url "https://github.com/1broseidon/cymbal/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "1265cefc42c2c7bc139175b9feffaad3effc0887917a6ba6bdea5d08f9097d53"
  license "MIT"
  head "https://github.com/1broseidon/cymbal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60dd6966a1894b870ed87b7528f8bb58d658938d2cf0d776367f5a15444c0824"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "343a96007dc13b3a0f1ab89c6efb98a78afba1c86b0e75cd80614946f2b14db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88767ce3f15ccde56b350cc8c4f949e92bcf9769ec2eaca7c9207e4d7fdf7eb9"
    sha256 cellar: :any,                 arm64_linux:       "8ccb1d2f31389cd9407faee7ea1e450a4cbb2ed44a3de3be8684a110cbea78d4"
    sha256 cellar: :any,                 x86_64_linux:      "14cda4fbec00134dbc004a3959038297d6ce770ca6bfd0de07d2b42401884c5a"
  end

  depends_on "go" => :build

  uses_from_macos "sqlite"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X github.com/1broseidon/cymbal/cmd.version=v#{version}"
    system "go", "build", *std_go_args(ldflags:, tags: %w[libsqlite3 sqlite_omit_load_extension])

    generate_completions_from_executable(bin/"cymbal", shell_parameter_format: :cobra)
  end

  test do
    ENV["CYMBAL_NO_UPDATE_NOTIFIER"] = "1"
    system "git", "init", "--quiet"
    (testpath/"main.go").write <<~GO
      package main

      func greet(name string) string {
        return "hello " + name
      }

      func main() {
        println(greet("brew"))
      }
    GO

    result = JSON.parse(shell_output("#{bin}/cymbal search greet --json")).fetch("results").first
    assert_equal "greet", result.fetch("name")
    assert_equal "function", result.fetch("kind")
    assert_match "hello", shell_output("#{bin}/cymbal search hello --text")
    assert_match version.to_s, shell_output("#{bin}/cymbal --version")
  end
end
