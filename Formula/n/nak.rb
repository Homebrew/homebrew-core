class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "c1865f8b85cd1dc875de13205f1bd1a26e9e367e8772ecb421b959ee6285f716"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d647f53c4e1f9f002a551be76eefdbf540c6b8e23e20dbab879a8f3e667ced18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d647f53c4e1f9f002a551be76eefdbf540c6b8e23e20dbab879a8f3e667ced18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d647f53c4e1f9f002a551be76eefdbf540c6b8e23e20dbab879a8f3e667ced18"
    sha256 cellar: :any_skip_relocation, sonoma:        "89bd2b08ac8e5e551204a63c5b12bb9b4344df46e6f7535cca6cd93e9b3d3d26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c71998103524770afb7d5c5fa911a229e24b0ea73b19c62f3f13ef5ef8d8367"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11f299fca29fe592722cba90a40f04afde2a04e01a4d78bde727803048b773f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  def shell_output_with_tty(cmd)
    return shell_output(cmd) if $stdout.tty?

    require "pty"
    output = []
    PTY.spawn(cmd) do |r, _w, pid|
      r.each { |line| output << line }
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      Process.wait(pid)
    end

    assert_equal 0, $CHILD_STATUS.exitstatus
    output.join("\n")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    assert_match "hello from the nostr army knife", shell_output_with_tty("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output_with_tty("#{bin}/nak relay listblockedips 2>&1")
  end
end
