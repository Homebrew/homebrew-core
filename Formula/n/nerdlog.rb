class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "425acc1b3461de136645040ba07153ee8157c58792c4983aec79240bcec2ccbd"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4e46592ebf350e71c095d6729b9b4555111b2a0de3f28ad759b827f2a032bf42"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d393e16cd4cb1866f10f8c7fc1e27570ceb2bd2943f865ce028156ce6fce382a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f396956887e95e33092cc96cf05ed34abd296cf99247cd3d1560fbfce2f16306"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7fae34f8cdc4bbaffeec1b89283e2dac68f725c80e8dbae8b841600660fec1b"
    sha256 cellar: :any,                 x86_64_linux:      "77aa7f45dd645f8d496f7730d07665b9abe7ea26fc5099fbae3fa831294d843d"
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
