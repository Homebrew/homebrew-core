class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.6.2.tar.gz"
  sha256 "374efef9a597c8f9fb95f83bbef7f8a031217f3a6106036eedeb1790509160da"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fde73f39be37839d20b62c3d2d7f6e750761f2b9f7a477b2050f9d69f74c492e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b321474fc24983d2405395d6ec73e3bf7dffc174639a73bfa4ba96420b345f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fcab566f1ffa2f73c8f44496ec513be55358b45ceafcf6eb9e7c79fbf9d66fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0de69cc37ca678c12d47746330d081647e221e10e71ea86e8f09c392b77419bc"
    sha256 cellar: :any,                 x86_64_linux:      "6dbcab6d555c5fddbcfe0088a002055234816d650f5d36eee0ad1b9627e2780f"
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
