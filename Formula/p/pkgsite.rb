class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e7091b7d1db3559b5cc2754c5f9fe6ab1ebf0d65462f8699f4855a18b15fc6b9"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81a69fc09bda084b278abbf2181e845ee492d853c7fd231dc42c942143ba5d64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a69fc09bda084b278abbf2181e845ee492d853c7fd231dc42c942143ba5d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81a69fc09bda084b278abbf2181e845ee492d853c7fd231dc42c942143ba5d64"
    sha256 cellar: :any_skip_relocation, sonoma:        "aff8659e1ec65827447c75cf4cfe9f48680aed9cefbf45ce7122023126634554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b26829257cdb739e01d2aa4bb12985b5296f4d51f887d941f3fdc0d7d9b0e057"
    sha256 cellar: :any,                 x86_64_linux:  "c79fdd8074e5cf46b6da34d07e5d9196d1e9e37f592b3de41cb323d695c74356"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/pkgsite"
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

    package_output = shell_output("curl -s http://127.0.0.1:#{port}/v1beta/package/example.com/testmod")
    assert_match '"modulePath":"example.com/testmod"', package_output

    symbols_output = shell_output("curl -s http://127.0.0.1:#{port}/v1beta/symbols/example.com/testmod")
    assert_match '"name":"Hello"', symbols_output
    assert_match '"kind":"Function"', symbols_output
    assert_match "func Hello() string", symbols_output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
