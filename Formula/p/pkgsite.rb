class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ec88faa9940cdcd58ed15058a1a932f81b4c3a21cf37b3119bf974a3137373fd"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bea59e96a94b29716c223383743fa690b707e4664ff1bf386cad8b5e8d17d239"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bea59e96a94b29716c223383743fa690b707e4664ff1bf386cad8b5e8d17d239"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bea59e96a94b29716c223383743fa690b707e4664ff1bf386cad8b5e8d17d239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "bea59e96a94b29716c223383743fa690b707e4664ff1bf386cad8b5e8d17d239"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "de5ea560f4f84d80072723b22dc9d804d933d06a3c39872cfd01107da76dfbfc"
    sha256 cellar: :any,                 x86_64_linux:      "814fc969c6ba654e77f16e63cd3fc6254aa60291efc8401efa36e3c6af64359e"
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
