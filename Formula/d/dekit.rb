class Dekit < Formula
  desc "Process manager for dev and prod"
  homepage "https://dekit.run"
  url "https://github.com/pvolok/dekit/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "6acfd19444a371ce04557af1a755accc4735c64e650704ae257aaf9f2e1168ba"
  license "MIT"
  head "https://github.com/pvolok/dekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4f0ac5fa01bd4e8c44b1cefdda90883bbe3ad421136fc2dcd21c225b42e962a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "436ac14df953d0942447c29fac1e06cdda3f9c24c523ac787e61fa5914ca1a57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f917630c922dd8d17aa4b2f7a0d8ab4d766dfe11f9bd00b67ff24219d49c42a"
    sha256 cellar: :any,                 arm64_linux:       "01143400623346d4e1d199a5e285befeb4697a438218170ff71f9aeb796a98d9"
    sha256 cellar: :any,                 x86_64_linux:      "a79471a9e40fdb05a026d5ef6460ad7a82948fef6b3ed6901e7cfece3d1b4706"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "src")
    # `dekit` symlinked as `mprocs` runs mprocs cli
    bin.install_symlink "dekit" => "mprocs"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dekit --version")
    assert_match "Usage: mprocs", shell_output("#{bin}/mprocs --help")

    require "pty"
    begin
      r, w, pid = PTY.spawn("#{bin}/mprocs 'echo hello mprocs'")
      r.winsize = [80, 30]
      sleep 1
      w.write "qx" # q opens the quit menu, x stops everything
      assert_match "hello mprocs", r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
