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
    shell_script = <<~EOS
      #{bin}/agent-browser &
      pid=$!
      sleep 1
      if ps -p $pid > /dev/null; then
        kill $pid
        echo "Success: agent-browser started and was killed."
      else
        wait $pid
        status=$?
        echo "Error: agent-browser failed to start or exited immediately with status $status."
      fi
    EOS
    assert_match "Success: agent-browser started", shell_output(shell_script)
  end
end
