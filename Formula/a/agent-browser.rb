class AgentBrowser < Formula
  desc "Browser for agents"
  homepage "https://cobrowser.xyz"
  url "https://storage.googleapis.com/cobrowser-images/agent-browser-1.5.0.tar.gz"
  sha256 "16b57ecd6b4182d5942c6c8b4fa2520424f1c46dc63300c645655cb406afc0b7"
  license "MIT"
  depends_on "go" => :build
  depends_on "templ" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "templ", "generate"
    system "go", "mod", "tidy"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/agent-browser"
  end

  test do
    ENV["NO_COLOR"] = "1"
    output = shell_output("#{bin}/agent-browser 2>&1")
    assert_match "2025-04-18T00:41:55-07:00 DBG provided module= output_types=", output
  end
end
