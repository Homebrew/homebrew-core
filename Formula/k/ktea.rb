class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.9.2.tar.gz"
  sha256 "ecf0eeadfc95aae9c1d812d4f52841dc8d5370cad72101cd33f5cf4d827acb3f"
  license "Apache-2.0"
  head "https://github.com/jonas-grgt/ktea.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4aefe083c3b815451a1ea956fc91e59812825150c902f37e4cfee221134b62a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4aefe083c3b815451a1ea956fc91e59812825150c902f37e4cfee221134b62a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4aefe083c3b815451a1ea956fc91e59812825150c902f37e4cfee221134b62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "189fbb60cad62e6fa90ef390181f7bbe2995ce6243b42cbcfe8f71302ef7bad4"
    sha256 cellar: :any,                 x86_64_linux:      "20470aca0f245fea2ff1a76ba7339e77a1e32a002081d164643497cd3a795dd7"
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
