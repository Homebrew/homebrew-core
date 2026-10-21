class Ktea < Formula
  desc "Kafka TUI client"
  homepage "https://github.com/jonas-grgt/ktea"
  url "https://github.com/jonas-grgt/ktea/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "4ad435de5503d8aa1d3f9b08a43e32d0482310791a8904b843b49037f73375d8"
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
    output_log = testpath/"output.log"
    pid = if OS.mac?
      spawn bin/"ktea", testpath, [:out, :err] => output_log.to_s
    else
      require "pty"
      PTY.spawn("#{bin}/ktea #{testpath} > #{output_log}").last
    end
    sleep 1
    assert_match "No clusters configured. Please create your first cluster!", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
