class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.5.tar.gz"
  sha256 "2558b6d44f661e4fb32d5146a6c76ce0c2af9a732baeeaf42c717e17245be8b2"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "177898b9a51e06b09013dbb752cd552bfe479ac7173a7ac6da53a73cf4928df1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "27a99c7a620c2181e03d131aba202dfc0fa9941328bd4abb49760d78a1650bae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f41ae46c48852a72442c848407a0921e6a92a492acc345c9e1f94084f8342159"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5dea17b3a5ca28def980fab1e6beda0622d86a90f756d41d5165824c7da4febb"
    sha256 cellar: :any,                 x86_64_linux:      "2363e7e81acdf1dd2190db5d09ec2f0105310923296b04ad0a147a65a5d3e80a"
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
