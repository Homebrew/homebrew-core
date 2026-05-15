class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.3.tar.gz"
  sha256 "f70f6d504688ebf53eb297c2cff2759eeed91af261abe5e5916b9241f6f229ea"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c7ee2a410b9055d372c67f881d2dc2e1b79143caec79572b4028d49436b255d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c7ee2a410b9055d372c67f881d2dc2e1b79143caec79572b4028d49436b255d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c7ee2a410b9055d372c67f881d2dc2e1b79143caec79572b4028d49436b255d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d46d9da923c216d35cf7fc8d51c82dcab869cb125583e3bcf82c90adbb4dc3ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eae390fa3850d7191abcf0cf2eb62d4dd4800c10feee444c7c4fe770d11ca4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82ca1d2f9b6b73e259b31e70e572f00428bc83a99e05b93de019fe6e2b966615"
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
