class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.2.tar.gz"
  sha256 "9ad752a5e87152c15698bac0f4157bcfa56918d49bc3947f3318e39e08be4f21"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c851313a8be3828137227fdebed6269cf2e59c71b1741269d4b054c5de69f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c851313a8be3828137227fdebed6269cf2e59c71b1741269d4b054c5de69f07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c851313a8be3828137227fdebed6269cf2e59c71b1741269d4b054c5de69f07"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8caab24baea7d4681896e0052f5419033240fa205b1573b2737f7177faa373b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e854fc4044ab9c2756027cf9bbff84b802328e75bb5fa08e98e9b5aade38b700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07e3c0dedd1e473d7a062ebcc3485590de130c1d2e8eb1a4ad92bfb348731741"
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
