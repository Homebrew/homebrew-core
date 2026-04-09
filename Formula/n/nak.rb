class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://github.com/fiatjaf/nak/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "5884ef06f162609f8e52c51377ed43b86b4b648815ff6dd11637a22c64189de7"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa65dfca099ee2e43b3237684dbc61f8560c9e80a663896fc278bf0b20b1825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daa65dfca099ee2e43b3237684dbc61f8560c9e80a663896fc278bf0b20b1825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daa65dfca099ee2e43b3237684dbc61f8560c9e80a663896fc278bf0b20b1825"
    sha256 cellar: :any_skip_relocation, sonoma:        "005ce6a7d0d451383024cd0d2b8aae8fab4351931ad6a24a6a2723bba813b75a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c2c8a60048b34f25250122e76ff3f3345edba91360b8d5c8a3300e21c3c42e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802375b069412d92183cf78bb740b8850493ed6242ac5308758d6c5356e27914"
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
