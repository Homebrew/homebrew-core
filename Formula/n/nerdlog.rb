class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "f9200cfa605a3b2724c0615118a1c3bb8dc32428133ac8077fa12c83a9e55976"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fb4a61c163f6d6ccc6f635213b1d80b23146df3ad55f1df384d1ef6ebb7b3c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9b4e0036ac9ac9d9c8ade6ee1ad0f0d144566724f6b061e599cfd6fdcdae14f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe61c13a8bae7365d6b083bdccd2518c3458c910fc8bb5ee2047cde75cad06a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e18f584a77f3460551346dee4cd171b6c277ae7df2a4bd735d1117ec56fba59a"
    sha256 cellar: :any_skip_relocation, ventura:       "e67f0c2d73df30174616281758b8a8719bc287a9eaf03adfb8702a156d470486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc16219735c2bc87d193951c8c04731d7347d3cf17567d33dc086482a45c07a9"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/dimonomid/nerdlog/version.version=#{version}
      -X github.com/dimonomid/nerdlog/version.commit=Homebrew
      -X github.com/dimonomid/nerdlog/version.date=#{time.iso8601}
      -X github.com/dimonomid/nerdlog/version.builtBy=Homebrew
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
