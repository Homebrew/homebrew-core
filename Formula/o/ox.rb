class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://github.com/curlpipe/ox/archive/refs/tags/0.5.2.tar.gz"
  sha256 "3741af45f1dd76feb8a2173164b4f85a21d6b55177fcc32eb76717915aa94934"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba37262498cd49256d98af1837bbfe18bab3c1a2e2a2f721adf5bf0261b60f0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d416549bafbef8dedb2db4190555a0fac6cd6157b3d50fa2f14c2bfe42f07db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf258237b2bd4c87786f5a1ab75f7810ffc3231c67a3833045430ecf5abafa48"
    sha256 cellar: :any_skip_relocation, sonoma:        "266b01a0c8cf104ad6042a734ec8fb2973b2526030cef6511f18c4c245c3d9b4"
    sha256 cellar: :any_skip_relocation, ventura:       "82b982bec3a8f0174e416da140be8cfd0b855d9bdf743a7592f71d3f98a1f20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7999d04f66bcdd65205aee5203a1edfadf2e60b423cd681731b55c36be44622"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
