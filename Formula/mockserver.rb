class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://oss.sonatype.org/content/repositories/releases/org/mock-server/mockserver-netty/5.11.0/mockserver-netty-5.11.0-brew-tar.tar"
  sha256 "458a2b8a62b17803a08385b0cc00df38128264cb5ab809f5f91d9ee5d56c327c"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"mockserver").write_env_script libexec/"bin/run_mockserver.sh", :JAVA_HOME => Formula["openjdk"].opt_prefix

    lib.install_symlink "#{libexec}/lib" => "mockserver"

    mockserver_log = var/"log/mockserver"
    mockserver_log.mkpath

    libexec.install_symlink mockserver_log => "log"
  end

  test do
    port = free_port

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
