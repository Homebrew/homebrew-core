class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.1.tar.gz"
  sha256 "3eab929ca02cab1a847880f49e6234acb6f6c547fa21cc9a8f9b515e91151c94"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5d9ff8fe35fd5d0309d0457c5dfbaeeceace4b973505251d272f015df976c0e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6ce6a3ee81413d5d8c9653e0f49405edc27f44c2b0f3bb7944f71684703e2ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b0f52774791e66c6fd736b66abb7fb533a4d132a90c0e118ec6c60abd8cfb68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4a3687262f02bc143ef5f805aae7170f2da821a05ca0ecce31bb13e65495a9be"
    sha256 cellar: :any,                 x86_64_linux:      "3aadb308bbaddec60598a70b310911d2ff16f07423360a63e7e26b7a316c6d4c"
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
