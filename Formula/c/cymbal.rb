class Cymbal < Formula
  desc "Language-agnostic code navigation CLI powered by tree-sitter"
  homepage "https://github.com/1broseidon/cymbal"
  url "https://github.com/1broseidon/cymbal/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "b9a988bcb30e638937a6af55c1e5cb0beaa46a72fcfcee9de314dcc955967895"
  license "MIT"
  head "https://github.com/1broseidon/cymbal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7d5420dd17a0e588164d534c8e8f074b9d7749cbdb707cae7de7d2392d4229ac"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "365e3625259a97a6b49f0fe5ad796e96281a4fe724eec228e2ac81430bd63cb3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9326478f1dc8536c429e20022b4972edf3fae3247a2ff820e14d6d6d98d6c67"
    sha256 cellar: :any,                 arm64_linux:       "7ec041d5e4855a614e5268dcb5a694c9252d1b7c3dc1505ab05a625c7b44f18b"
    sha256 cellar: :any,                 x86_64_linux:      "c4f84b2b1fd624c52a85fbb8dd9dd92a2824084c17e15787aea7483821ab2a0c"
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
