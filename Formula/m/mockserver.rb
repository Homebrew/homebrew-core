class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/9.0.0/mockserver-netty-9.0.0-brew-tar.tar"
  sha256 "6b55aebb2cdb464aa9d842cbafa32e8ec64f27a211bf8d05fc1947f26c74f215"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "34147b256a2355f3cfaf5410f364f047944f0c28423eff824c45ede81328c9f8"
  end

  depends_on "openjdk"

  allow_network_access! :test

  def install
    inreplace "bin/run_mockserver.sh", "/usr/local", HOMEBREW_PREFIX
    libexec.install Dir["*"]
    (bin/"mockserver").write_env_script libexec/"bin/run_mockserver.sh", JAVA_HOME: formula_opt_prefix("openjdk")

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
