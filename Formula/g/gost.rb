class Gost < Formula
  desc "GO Simple Tunnel - a simple tunnel written in golang"
  homepage "https://gost.run/"
  url "https://github.com/go-gost/gost/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "2a65e2da14fef6b6da8d4e32a8bc62e39970dbb141db42bc6f5821f90ac1e9a3"
  license "MIT"
  head "https://github.com/go-gost/gost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7e11381ed2b3399e26e4867a65d4714af69890f895239956de2f2d5e951ec6d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7f7625d05dbe9b50a1f7dac7bfa17a5e9683ab3ea865c62ebdf12c4bc380e9fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d4e8bf9fa72d8eb49ffb1ce702f8f01f3a230a7b292d28e18d0187430e7c230"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "1238386751302b5bca7602e0ff2074a4e2b3474ae664d10b7006ce28d94d1901"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1719e4fcdab08676af111c791e8407a9a2fe899a2503c0f499eb57fcfeb2ff85"
    sha256 cellar: :any,                 x86_64_linux:      "c7847986d95a3eeb747872885f2bce043229758187977b28a8bd459870b18df8"
  end

  depends_on "go" => :build

  conflicts_with "vulsio-gost", because: "both install `gost` binaries"

  # `test do` block runs a local proxy server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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
