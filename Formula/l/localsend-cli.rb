class LocalsendCli < Formula
  desc "Open-source cross-platform alternative to AirDrop"
  homepage "https://localsend.org"
  url "https://github.com/localsend/localsend/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "b7bc1b01a4d65ff12fa1e13e6e22b7130fa3203bfcb46793e67afc0741d3d365"
  license "Apache-2.0"
  head "https://github.com/localsend/localsend.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    # Test discovery
    require "pty"

    # An identity file is created in the config folder preventing two instance
    # with the same config from dicovering each other
    config1 = testpath/"1"
    config1.mkdir
    config2 = testpath/"2"
    config2.mkdir

    ENV["XDG_CONFIG_HOME"] = config1.realpath
    r1, _w, pid1 = PTY.spawn(bin/"localsend-cli", "--port=#{free_port}")

    ENV["XDG_CONFIG_HOME"] = config2.realpath
    _r, _w, pid2 = PTY.spawn(bin/"localsend-cli", "--port=#{free_port}")

    # Give time to discover each other
    sleep 1

    Process.kill("TERM", pid1)
    Process.kill("TERM", pid2)

    # Collect r1 output
    output = +""
    begin
      output << r1.readpartial(4096) while true
    rescue EOFError, Errno::EIO
        # EOF on macOS, EIO on Linux.
    end

    # Check if a peer has been discover ie: D [1]
    assert_match "D\e[39m [1]", output

  # Cleanup
  ensure
    Process.wait(pid1) rescue nil
    Process.wait(pid2) rescue nil
  end
end
