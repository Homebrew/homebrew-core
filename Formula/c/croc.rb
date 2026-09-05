class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.4.0.tar.gz"
  sha256 "a5f06d9364e8ea41e60ba1ca7251f33f930fc91b3e4fdd510f8d6e99b463283e"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10556619b2fcbc262b049aa270bb39afb4a7a68061126a1732235dacf28a14b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6c2cd7d9d89f3bd7d78b3f0cf30dba2cc6992e39997a23aa76726f1ffac0287"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fb6c4db20eae846e028d8321eb51b54f0bd1ee8a10935962a9d2aab5844cec0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ddb53eb582d9f07cfe810a6e54b2a44b9a71cafa2e79eb9f789e7b36937cf25"
    sha256 cellar: :any,                 x86_64_linux:  "765f6292e2e58e679b10beb1e4936e3ef2eb93a0fa57af46396f35f040eef227"
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
