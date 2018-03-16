class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/5.3.0/mockserver-netty-5.3.0-brew-tar.tar"
  sha256 "323fe846d9a6e47d508d26a428b5d6748572b814569aecdd65916dc7279f1308"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/run_mockserver.sh" => "mockserver"

    lib.install_symlink "#{libexec}/lib" => "mockserver"

    mockserver_log = var/"log/mockserver"
    mockserver_log.mkpath

    libexec.install_symlink mockserver_log => "log"
  end

  test do
    require "socket"

    server = TCPServer.new(0)
    port = server.addr[1]
    server.close

    mockserver = fork do
      exec "#{bin}/mockserver", "-serverPort", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/status", "-X", "PUT")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/stop", "-X", "PUT"

    Process.wait(mockserver)
  end
end
