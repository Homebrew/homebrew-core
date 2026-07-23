class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v10.5.0.tar.gz"
  sha256 "e1a8053091dd00e0c5b9949374df1e2f0671e0d98ea8ff81a447c421312246e4"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fa677d3fbb2f1a1d154263e6ba77ddcb6de9901399699a99fd22d60dfd7359e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fa677d3fbb2f1a1d154263e6ba77ddcb6de9901399699a99fd22d60dfd7359e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fa677d3fbb2f1a1d154263e6ba77ddcb6de9901399699a99fd22d60dfd7359e"
    sha256 cellar: :any_skip_relocation, sonoma:        "85ffea6e44b24dddde3cf6a04c6866d8fd2b01a4f3bb55de13c3fb30b4250b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f0a9d4381a370c14b2aad6c268464ed339d565baa2a15f0a32ae1d6373826d1"
    sha256 cellar: :any,                 x86_64_linux:  "1cc3af0a910427af31be5031acad70954553917465e655e1ff933562aaf0545d"
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
