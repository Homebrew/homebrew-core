class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c8c0a319ade7fa9b87561aaf61b57694080060a76afc1d7dc035759e3eb76b39"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "579e21770ea529f87a29a9b78301625f831178e07a497fd7ca1fb95cd73d185b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "282d2bbe10f808ef3e409431d41d6f5bac1c748f44c230beca3edc098e74cb1f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "282d2bbe10f808ef3e409431d41d6f5bac1c748f44c230beca3edc098e74cb1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "282d2bbe10f808ef3e409431d41d6f5bac1c748f44c230beca3edc098e74cb1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "308ee203af03d54508cc753c56dab86aebe29ace8095c7466fde0fc02f9b59c8"
    sha256 cellar: :any,                 x86_64_linux:      "096260ae22fa27d01553c2b324b1b71e0c0eae434823a953c3cc5d99443962da"
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
