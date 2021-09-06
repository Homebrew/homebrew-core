class Microsocks < Formula
  desc "Tiny, portable SOCKS5 server with very moderate resource usage"
  homepage "https://github.com/rofl0r/microsocks"
  url "https://github.com/rofl0r/microsocks/archive/v1.0.2.tar.gz"
  sha256 "5ece77c283e71f73b9530da46302fdb4f72a0ae139aa734c07fe532407a6211a"
  license "MIT"
  head "https://github.com/rofl0r/microsocks.git", branch: "master"

  def install
    # fix `illegal option -- D` issue for the build
    # upstream issue report, https://github.com/rofl0r/microsocks/issues/42
    inreplace "Makefile", "install -D", "install -c"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    port = free_port
    fork do
      exec bin/"microsocks", "-p", port.to_s
    end
    sleep 2
    assert_match "The Missing Package Manager for macOS (or Linux)",
      shell_output("curl --socks5 0.0.0.0:#{port} https://brew.sh")
  end
end
