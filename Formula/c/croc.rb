class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.4.tar.gz"
  sha256 "e77f051d3470020d856b22240c2edb09fcd93b059611358157656d8833667722"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4cfafeb75ddf6779021be40d1614b6c4783338b88125c0ae4268f772a7e44b91"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ac122227db4f31ccbb8ec4ffd4b1c085722ce53269f4ff794a638d6ddc39787f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "44a06e23bdb553074d7e768383ee76832dd91a05a61488c34b8f254cf31dbbe1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85e8482f9fbcc77de3bbb7efbee46e389cac9d4914e4422e3aa7c97a154683aa"
    sha256 cellar: :any,                 x86_64_linux:      "733fcf52d1c6a792cf6d6654915a521bc8f02b831f9466c9643b47598f172c26"
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
