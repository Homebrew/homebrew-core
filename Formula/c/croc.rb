class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.3.tar.gz"
  sha256 "41f5c334be83978fea3f6c90d9b77320db3b381bc65ab57d684c091dd6a1d964"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a932579f72e41f7ae1231287a9e393bde9f5779f23edb61b722231037057893b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9b3584dff0edc2f2fb5c5a937888629d3e0393931da382dbd05608018db6e894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ffedac1685d0538501a111044fc7e8a6a765cf8f4f358a8f2798dcb9c387f6a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2adad844e72ef404d5c67cddc7183bf11d34bd3500a6798c7f9f264c06a2b9fc"
    sha256 cellar: :any,                 x86_64_linux:      "35e48d6e2c112288fbee8a00a0dd431461b860d520c5220a7d1df1fbf0eeb87d"
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
