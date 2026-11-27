class Mockserver < Formula
  desc "Mock HTTP server and proxy"
  homepage "https://www.mock-server.com/"
  url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/9.4.0/mockserver-netty-9.4.0-brew-tar.tar"
  sha256 "486ad7466b706c6aa67dd8c1bd82cda80d32c340955b797d96d571a0bba8b155"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/mock-server/mockserver-netty/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  bottle do
    manifest_sha256 "5f235541a9f1ae044487d4eb2a6cd68dd126b7bcda9a1ce7e0cb6bbed5fc477a"
    sha256 cellar: :any_skip_relocation, all: "d845bea868d120b7495a7be3c013940c777f141f936cf529b1fa4f3e5e9a9e05"
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
