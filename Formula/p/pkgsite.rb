class Pkgsite < Formula
  desc "Documentation server for Go packages"
  homepage "https://pkg.go.dev/golang.org/x/pkgsite"
  url "https://github.com/golang/pkgsite/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3a7dcb16a6e21ae8cb8f07c48bf6cfd501e9414fb2048bb79c5a0845b1c31d99"
  license "BSD-3-Clause"
  head "https://go.googlesource.com/pkgsite.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57aca65a0a4805d2848d476405806243de8cd6c478e9111c2bd9863e8ea4eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c57aca65a0a4805d2848d476405806243de8cd6c478e9111c2bd9863e8ea4eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c57aca65a0a4805d2848d476405806243de8cd6c478e9111c2bd9863e8ea4eae"
    sha256 cellar: :any_skip_relocation, sonoma:        "25ca6d6bfa9f7487917589902a22ee0779b48f6d0dcf540d98e86a7f3c1db977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c00f9975ea654cd5266aadfe8ad4eda985f34790665a53ea31832b2c785c4156"
    sha256 cellar: :any,                 x86_64_linux:  "c3011416b1e225b6d6a78db921b746a046baecf9b1abe9046ab6c9ed7b9d4251"
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
