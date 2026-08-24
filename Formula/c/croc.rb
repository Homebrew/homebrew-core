class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/refs/tags/v11.3.0.tar.gz"
  sha256 "2af2b2cc379c4a913ee471e7ce157d6bb4ec7a391f0f26f6b870e9422c3ff55b"
  license "MIT"
  head "https://github.com/schollz/croc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "976c0155f847ee1e8156d79740509c8f6d2c06f44d55fee1349e57bc69e01490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "976c0155f847ee1e8156d79740509c8f6d2c06f44d55fee1349e57bc69e01490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "976c0155f847ee1e8156d79740509c8f6d2c06f44d55fee1349e57bc69e01490"
    sha256 cellar: :any_skip_relocation, sonoma:        "41da0e902fd98041d2bfa1225ffc00c958a1e4b96acc6588d1b91ce5d724b7ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b83a72266a079096d2a222599820c81a107921b7063a32e63e6b5b782407b28e"
    sha256 cellar: :any,                 x86_64_linux:  "d7d5dce9d34a6ea8a641a871b2380a3c57df95689520a33b6fda6abc346e44e0"
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
