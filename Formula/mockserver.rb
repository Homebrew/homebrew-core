class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/5.14.0/mockserver-netty-5.14.0-brew-tar.tar"
  sha256 "235ebe34e9317de685693bcffe57df7144cc102952a4267e6dfa9548063a1268"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8b245368e18ec88c1e2a297a84bf965a9e877a0413377c481aa5704fc0740dc"
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
