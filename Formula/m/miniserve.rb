class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "48351a8165bd51f3c855695af1c25032b502f873c80f52f98a538174951cbb9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0737d1957f73bbd2eab87296da1781bc7bd4de476715fce743abf4dbf0bf4333"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ee123de7e3a28158c1f54c80212f2805b5456054c7eac394e37e2d5b5dcba4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e775b2fc727210da8bf295ecbc0dd02b013af0e0bb4a90e0dd540391074cdc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8b4efb102194aa5934ff2a666b2dc602a676a4ae895e4099202974b4b464e06"
    sha256 cellar: :any_skip_relocation, ventura:       "b1535654a5a0e5c5907340965c8dcd3e2bbc3430afbbe794a70df7a1e98920c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6762e154da3ffc86f85cc9d67a1bb9a2b666696e6f1490bf9ebec53dca88ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3abba9ddbbe7f139aa9cccbbd15d1eb3067e3e3881c437b9fea20274934a58d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
