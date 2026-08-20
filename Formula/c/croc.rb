class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.2.3.tar.gz"
  sha256 "99d59ae337ad1ea503e540b14961227be5217667eaee77a33672cb8dd597a35f"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8dd489e79b4ffa9882bbc293b98017bf8d3417802dae0fc2917e983e5408b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8dd489e79b4ffa9882bbc293b98017bf8d3417802dae0fc2917e983e5408b86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8dd489e79b4ffa9882bbc293b98017bf8d3417802dae0fc2917e983e5408b86"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8316ea838e20d96f51dd51f996eec37f42042633cc81c3da64938fe4b9259e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c5d5e9bd5f6abf04b67eb366e6383f0cf30dfdbbf29d024a1cbf27358f3cdcf"
    sha256 cellar: :any,                 x86_64_linux:  "c9604d084bffd069cff4a70f408d54cb2ca7ca1fc7e9302086bb1664095617b3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.first}", "send",
                                     "--no-local", "--text=mytext", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.first} --overwrite --yes")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end
