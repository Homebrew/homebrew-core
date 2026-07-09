class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.4.12.tar.gz"
  sha256 "9eeb03fef37159619a2e5a668995d4aa5dbab3d9acfa395841d08ffbcae54c02"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "543f243182c40ed91ab25f991d9cfe4387f4d67b56944e48bf7a6889529a824d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "543f243182c40ed91ab25f991d9cfe4387f4d67b56944e48bf7a6889529a824d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "543f243182c40ed91ab25f991d9cfe4387f4d67b56944e48bf7a6889529a824d"
    sha256 cellar: :any_skip_relocation, sonoma:        "c85d12b19682bea13942bd5d1cb3e730e940a5819f6fe0aba3c5718933a86490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb806c17ee81da7fcc805973a905ef97e5c46ca3845a909dd2c076941b1f43f2"
    sha256 cellar: :any,                 x86_64_linux:  "e7cc41ef603279910781699014c121a6cb81803228af3f9714914909f66ca783"
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
