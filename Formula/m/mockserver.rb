class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/7.0.0/mockserver-netty-7.0.0-brew-tar.tar"
  sha256 "b6aacd2e26d38c3de483b50108bdb6bd46bcbd94563c4471dfc5c26ecaaeb153"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "42981103af4208b66a085c746ed87f80c1cc1255f1effda4d6d23f84fb6088d2"
  end

  depends_on "openjdk"

  def install
    inreplace "bin/run_mockserver.sh", "/usr/local", HOMEBREW_PREFIX
    libexec.install Dir["*"]
    (bin/"mockserver").write_env_script libexec/"bin/run_mockserver.sh", JAVA_HOME: Formula["openjdk"].opt_prefix

    lib.install_symlink "#{libexec}/lib" => "mockserver"

    mockserver_log = var/"log/mockserver"
    mockserver_log.mkpath

    libexec.install_symlink mockserver_log => "log"
  end

  test do
    port = free_port

    mockserver = spawn bin/"mockserver", "-serverPort", port.to_s

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/status", "-X", "PUT")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/stop", "-X", "PUT"

    Process.wait(mockserver)
  end
end
