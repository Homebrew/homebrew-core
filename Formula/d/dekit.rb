class Dekit < Formula
  desc "Process manager for dev and prod"
  homepage "https://dekit.run"
  url "https://github.com/pvolok/dekit/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "175467fb30195c084df4bd38bf2000fad80f7e03b1e3488c29e3b114f3587ca9"
  license "MIT"
  head "https://github.com/pvolok/dekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8419898240bc8a5758aaaacae90cb3440762e4da4c495ac92e2f6aa8294dd50b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f97d29329ced8fb3335a48881f06183aff2b9b0fdccfbfd94b0b590a25db1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "64f0a7eddb055b3d0dce0407f851e78c917ef068c54e5d3659660000fa4601d2"
    sha256 cellar: :any,                 arm64_linux:       "00f3afef623b98e2cc74ac1b99315db0057b95d2c9ec62b5e4a15d88b9ea878c"
    sha256 cellar: :any,                 x86_64_linux:      "329625bb18156e92cd67286a9e9b7a774cd7de7c072b4c1624788db09d4766f9"
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
