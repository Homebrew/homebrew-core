class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "7cc5627428e42bf5a8f99608d704a98cd888fbff2bb2bf292f14f0af15b5692a"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "399d070feceabd99a1da7dcaaf77a848e5e0bc5ce74c11e85c791d53a5666413"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "399d070feceabd99a1da7dcaaf77a848e5e0bc5ce74c11e85c791d53a5666413"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "399d070feceabd99a1da7dcaaf77a848e5e0bc5ce74c11e85c791d53a5666413"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a2ddb5a4ee1a0381547289212385dd0f6b76cd17a5205ad36a91b5ba384a576"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23e681a207a737aa7053be601aae567bcbdc3bfe558af9658d66de2f9bec94aa"
    sha256 cellar: :any,                 x86_64_linux:  "1d5c2974829ec84b0ffe43f7c6a976e930b26484bbef1596630a97b828d929e4"
  end

  depends_on "go" => [:build, :test]

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
