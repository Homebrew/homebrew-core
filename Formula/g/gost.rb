class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.2.6.tar.gz"
  sha256 "79874354530b899576dd4866d3b1400651d0b17c1e7a90ad30c44686a0642600"
  license "MIT"
  revision 1
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b479036a3b88053d0179e28ccfb4a980ed85c4e1ebc67dd057c978a2f0f652"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b479036a3b88053d0179e28ccfb4a980ed85c4e1ebc67dd057c978a2f0f652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2b479036a3b88053d0179e28ccfb4a980ed85c4e1ebc67dd057c978a2f0f652"
    sha256 cellar: :any_skip_relocation, sonoma:        "57e90424f843be0b5f37193136821911635ae73030e958d272461d07ad873a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3ad1f20070403dc1f8ef7b85eaddce8f42c59d6c063c5c3943947a4ac2b8948"
    sha256 cellar: :any,                 x86_64_linux:  "b37dcfc8866962bc64508f8dfb3c47f301b0eebf1d9f3c5960df0543f6a2a577"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  def install
    system "go", "build", *std_go_args, "./cmd/gost"
    prefix.install "README_en.md"

    etc.install "gost.yml"
  end

  def caveats
    <<~EOS
      The config is installed to #{etc}/gost.yml.
    EOS
  end

  service do
    run [opt_bin/"gost", "-C", etc/"gost.yml"]
    keep_alive true
  end

  test do
    bind_address = "127.0.0.1:#{free_port}"
    (testpath/"gost.yml").write <<~YAML
      services:
        - name: test
          addr: "#{bind_address}"
          handler:
            type: auto
          listener:
            type: tcp
    YAML
    pid = spawn bin/"gost", "-C", testpath/"gost.yml"
    sleep 2
    output = shell_output("curl --max-time 10 -I -x #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)

    output = shell_output("curl --max-time 10 -I --socks5-hostname #{bind_address} https://github.com")
    assert_match %r{HTTP/\d+(?:\.\d+)? 200}, output
    assert_match(/Server: GitHub.com/i, output)
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
