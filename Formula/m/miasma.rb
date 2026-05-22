class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "081bdccc2cfe1a9889dbb842006a4ee6fb5764dd5835a42955d46f36d8ba3db2"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s
    end

    begin
      require "timeout"
      Timeout.timeout(10) do
        loop do
          break if system "curl", "-sSf", "http://127.0.0.1:#{port}/"

          sleep 0.2
        end
      end
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
