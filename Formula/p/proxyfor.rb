class Proxyfor < Formula
  desc "Proxy CLI for capturing and inspecting HTTP(S) and WS(S) traffic"
  homepage "https://github.com/sigoden/proxyfor"
  url "https://github.com/sigoden/proxyfor/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "f4e2340dbce232333ce05473b75f3b1eacf27d1699071b52a9cf420a8c47fd96"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/proxyfor --version")

    port = free_port

    require "pty"
    PTY.spawn "#{bin}/proxyfor --dump -l 127.0.0.1:#{port}" do |r, _w, pid|
      sleep 5
      system "curl -A 'HOMEBREW' -x http://127.0.0.1:#{port} http://brew.sh/ > /dev/null 2>&1"

      Process.kill("TERM", pid)

      output = ""
      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end

      assert_match "# GET http://brew.sh/ 301", output
      assert_match "user-agent: HOMEBREW", output
    end
  end
end
