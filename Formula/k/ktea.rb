class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "48ceec1fec901fea9e6b6ed10c1a73539dd9879d11ea5b1a7c1f128d8d955f08"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "09aeed48dd2e16dc5810b40fa1c4e139dbb60665e0705fe0fe17b2aacfab25e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "09aeed48dd2e16dc5810b40fa1c4e139dbb60665e0705fe0fe17b2aacfab25e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09aeed48dd2e16dc5810b40fa1c4e139dbb60665e0705fe0fe17b2aacfab25e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "961f31998caae9b59b26c4da397833f853f7aa1a6ec0da300319cccd9ba91bcf"
    sha256 cellar: :any,                 x86_64_linux:      "e84b0cf20ab9452f7fd13f4f26edbfa0fd7aa66449f26c47f269beeaf3ff11b7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(tags: "prd"), "./cmd/ktea"
  end

  test do
    require "expect"
    require "io/console"
    require "io/wait"
    require "pty"
    require "timeout"

    config_file = testpath/".config/ktea/config.yaml"
    config_file.dirname.mkpath
    config_file.write "{clusters: [], plainFonts: true, theme: dracula}\n"

    r, w, pid = PTY.spawn({ "TERM" => "xterm-256color" }, bin/"ktea")
    r.winsize = [30, 120]
    r.expect(/Clusters/, 10)
    w.write "\u000c" # Open Settings.
    r.expect(/Themes/, 10)
    w.write "\e[H\r" # Apply the first built-in theme.
    Timeout.timeout(10) do
      r.readpartial(4096) until YAML.load_file(config_file)["theme"] == "catppuccin"
      r.read_nonblock(4096) while r.wait_readable(0.1)
    end
    assert_equal({ "clusters" => [], "plainFonts" => true, "theme" => "catppuccin" },
                 YAML.load_file(config_file))
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
