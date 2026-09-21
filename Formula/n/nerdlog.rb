class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "a4027f3667d14eac04f64e2c8312823953caf47ccc6f5b6055f9c28a8c53fda7"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81ed87fba9226d415496bfe59b2150417eff0f6a67146eef47391210a61e010c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec818d81463d5099aa08285273d7e988f306b9b3e29f58c67416368ce7c7986e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6043912c1b993c4b4cc44341e1c80f1288714c46b8d9df97abe491fad663be2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91cabafef3277d057ae8d4aec4aee5d3cb3c0cfffbeec30a9a7d52362faf1f1a"
    sha256 cellar: :any,                 x86_64_linux:      "5737f5c9e88ff61065067a921224c582e7a34ded52886b5cbc6a6d49c100ff29"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/dimonomid/nerdlog/version.version=#{version}
      -X github.com/dimonomid/nerdlog/version.commit=#{tap.user}
      -X github.com/dimonomid/nerdlog/version.date=#{time.iso8601}
      -X github.com/dimonomid/nerdlog/version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdlog"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"nerdlog") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        output = r.read
        assert_match "Edit query params", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, shell_output("#{bin}/nerdlog --version")
  end
end
