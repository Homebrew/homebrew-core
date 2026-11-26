class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.7.tar.gz"
  sha256 "2481acb7c027c89201979cfddf848826ff485512c36eed364e174c3b032c8748"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    manifest_sha256 "6b22e39522e02509b83f8bf7357e8e049f0a6da09adcf87f9810484a9c79bac7"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0050c357573e098c718730c2cb8e2d27e75670fa1c77e59897bb4d3f5e43753a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6cfdae580239ec4e0a410753bf266ece2754849e7b6593d90e5e464b5407aaed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "24ee3efbefd9037713a479d8e8faf71ec2c804547c2a341dd94e9bff61892585"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "290e45371eef0aba315e1a39b5a0a5cf8fce79338456be01a3498b7083c431d7"
    sha256 cellar: :any,                 x86_64_linux:      "973ff1045919d6f16a60c54f5ad3f0b8f2b7980e846e8d9b3ab971fd217dd3a0"
  end

  depends_on "go" => :build

  # `test do` block runs a local relay
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
