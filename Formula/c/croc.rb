class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.2.4.tar.gz"
  sha256 "583d6174593fd59e92565cdbf8424c9307efb22ffa66acc70f3539500158e9c5"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bafb96d89b977897be4d92ec4376309a126c3f8a94676ce406698fa18751a612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bafb96d89b977897be4d92ec4376309a126c3f8a94676ce406698fa18751a612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bafb96d89b977897be4d92ec4376309a126c3f8a94676ce406698fa18751a612"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a8e50db27b1d0c10ff56bb12ea21c0b4d02fab5f6b42611a5f9fa1b1ddde35d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14c1bbf87025491fe2599d3fe109d0c75ac38daca035b10b438336dba0c87d94"
    sha256 cellar: :any,                 x86_64_linux:  "9006a7ac35a445a8d67beed1a160466b1837e98097abfcc95985e2518ed08527"
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
