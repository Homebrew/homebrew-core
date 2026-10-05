class Cymbal < Formula
  desc "Language-agnostic code navigation CLI powered by tree-sitter"
  homepage "https://github.com/1broseidon/cymbal"
  url "https://github.com/1broseidon/cymbal/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "093a6e49b1e66d65d396bbd3ce391e5e239f725047494b905af54daf60324a54"
  license "MIT"
  head "https://github.com/1broseidon/cymbal.git", branch: "main"

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
