class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.4.tar.gz"
  sha256 "33e9160829705942178a017ce055196c4a66c9ef5cdfe8029e840be835e756d4"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73bdd8bb8b6fb368bce069c96adcac1f9e80224e34aeb86bfb96d943f61a77db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73bdd8bb8b6fb368bce069c96adcac1f9e80224e34aeb86bfb96d943f61a77db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73bdd8bb8b6fb368bce069c96adcac1f9e80224e34aeb86bfb96d943f61a77db"
    sha256 cellar: :any_skip_relocation, sonoma:        "b09ae339fd1f2f485f7c0b9692a2cc88de01e6bb05d3baa3c57c98fb000f6fc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68ca7542f9d70da438311fe511c4f48feae43f4e8d5672a35b9ada6e6cb15f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c6abdfd190f1ab4152d2eba7275ad1c23e840d817ee0da781ed564fe12d2dbe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # As of https://github.com/schollz/croc/pull/701 an alternate method is used to provide the secret code
    ENV["CROC_SECRET"] = "homebrew-test"

    ports = [free_port, free_port]

    require "pty"
    pid = PTY.spawn(bin/"croc", "relay", "--ports", ports.join(",")).last
    sleep 3

    pid_send = PTY.spawn(bin/"croc", "--relay=localhost:#{ports.last}", "send", "--code=homebrew-test",
                                     "--text=mytext", "--port=#{ports.last}", "--transfers=1").last
    sleep 3

    output = shell_output("#{bin}/croc --relay localhost:#{ports.last} --overwrite --yes homebrew-test")
    assert_match "mytext", output
  ensure
    Process.kill("TERM", pid_send)
    Process.kill("TERM", pid)
    Process.wait(pid_send)
    Process.wait(pid)
  end
end
