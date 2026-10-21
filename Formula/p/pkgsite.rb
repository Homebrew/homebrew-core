class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "63643f608bf927d35b5216cf546b7c52d90ec88190a2c83cc78eca5d42191d61"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "41196526d83f2b7918d0ace9b92a759eff1128da12da35e58b068d1fea93a044"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "41196526d83f2b7918d0ace9b92a759eff1128da12da35e58b068d1fea93a044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "41196526d83f2b7918d0ace9b92a759eff1128da12da35e58b068d1fea93a044"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ca159b28012fd6a341d17422a81769f8d2606833db5362c13b8d8c40e056d992"
    sha256 cellar: :any,                 x86_64_linux:      "576294f06157b6cece61cef83caf2cc101c65a20608b944d432e7afecab43115"
  end

  depends_on "go" => [:build, :test]

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/pkgsite"
  end

  test do
    require "socket"
    require "timeout"

    port = free_port

    testmod_path = testpath/"testmod"
    testmod_path.mkpath

    (testmod_path/"go.mod").write <<~MOD
      module example.com/testmod

      go 1.26
    MOD

    (testmod_path/"main.go").write <<~GO
      package main

      func Hello() string { return "hi" }
    GO

    pid = spawn bin/"pkgsite", "-http", "127.0.0.1:#{port}", "-cache", testmod_path

    Timeout.timeout(60) do
      loop do
        TCPSocket.new("127.0.0.1", port).close
        break
      rescue Errno::ECONNREFUSED
        sleep 0.2
      end
    end

    raise "pkgsite exited unexpectedly" if Process.waitpid(pid, Process::WNOHANG)

    package_output = shell_output("curl -s http://127.0.0.1:#{port}/v1/package/example.com/testmod")
    assert_match '"modulePath":"example.com/testmod"', package_output

    symbols_output = shell_output("curl -s http://127.0.0.1:#{port}/v1/symbols/example.com/testmod")
    assert_match '"name":"Hello"', symbols_output
    assert_match '"kind":"Function"', symbols_output
    assert_match "func Hello() string", symbols_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
