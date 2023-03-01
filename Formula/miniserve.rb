class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.23.0.tar.gz"
  sha256 "46e076f35cd8919a566d595b7fef05ce9c5c223a66bea6ee6dd3092c42697bd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9cb889ae23041f70db81cd6aa3075d9f99bb726875a595a634100d460df4702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8087c2fc1f3ea672221b31ff4ea5ccafa4189b4f38fbb924e7e48c6633ff611"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e175d06b9f5b09687bf3e4fb67c804ea82a97a90d8a45c5e6d11bb7113662f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "334cf68cd004ed5cf1bd92d8b04f401a6cab0f5860d813ebc85b42f24ed97279"
    sha256 cellar: :any_skip_relocation, monterey:       "0ebc9b6c83339eec7ca4662e9128876efa1a5b45ae5303769549678c5903edf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e283f0b5903041052a26ddc891c5f1ce0a47516c78ba47ac18f847563e4144f"
    sha256 cellar: :any_skip_relocation, catalina:       "997bafd79ff359bae8980be257c34a3c264f5d9bb125fbe2d22ef897a6295487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46e86908e63b87be92bd74d8594dcffbfd5dc6837268852d319e790eca67e9b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/miniserve", "#{bin}/miniserve", "-i", "127.0.0.1", "--port", port.to_s
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
