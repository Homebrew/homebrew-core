class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.2.tar.gz"
  sha256 "374efef9a597c8f9fb95f83bbef7f8a031217f3a6106036eedeb1790509160da"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f20a0ca02a2878c49d268af1c01a724d74bbb7735a2e3dabda954dbe874bac24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d257bec7a930f01391df0708dad143ebacc47f95a34e3346e02976c12a9e01cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7e9a7f8cc44184b4cf308803fcd080fc9dcecb2a8102af472a02331068d26612"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a4aefb5dc10069d9993ff112f5f1756d72e79f1bf33e0ee28a3bd50719c56226"
    sha256 cellar: :any,                 x86_64_linux:      "cc7aba5b6558b26c002383050cc458d9d14987e12190e51ecd1bd9e2d2c54027"
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
