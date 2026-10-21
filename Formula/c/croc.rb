class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.5.5.tar.gz"
  sha256 "1263e430cd62654438c9724072b7d5587e9930ca0e687d65b3dd8917ec0141df"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fb870b2b58fb93175f5bedde9cae2e0732cac076f3b123a2b74d99e8dbec5c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "20f81e2d97bcdb8f4ae5de604b9a47e7721a42f869f3d3a015057cd66bcbedde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d7ae0decd5b1919ac57b03af8d05643d101bcb9a4d35e90286ebd63fdd5abfd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7f0464c4c17f0a65837c5fb0ab633e3e751a826cf8ae2f08cfa3df52051b17b3"
    sha256 cellar: :any,                 x86_64_linux:      "5e3c2678a3e9c5e7ce6175f2f2d8bd5b5b00b8e61b86363137082a9e0f3c71e1"
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
