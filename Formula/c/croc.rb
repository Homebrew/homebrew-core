class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.6.tar.gz"
  sha256 "3eed8662dc8c2ff9620f266aa1a47d1445f5b86c682e1e1ca6616bcd407e27c2"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3969f58cb0f474c2ab615b5ef333749a3cbaefcb5f9a238efd942733267f21d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3969f58cb0f474c2ab615b5ef333749a3cbaefcb5f9a238efd942733267f21d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3969f58cb0f474c2ab615b5ef333749a3cbaefcb5f9a238efd942733267f21d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "81fcaaa8d2f9115f7ecdf69f641025101712d9120858f6e1fcaf4aac1ed1ef4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bd20edfe11f9b0aa18b69f301e53deebfa66aa4eebd2c29221dec9bc8a65eec"
    sha256 cellar: :any,                 x86_64_linux:  "ddcc5ea017919f606c12e7579718245bf68306c3b753af77493462fb802945d0"
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
