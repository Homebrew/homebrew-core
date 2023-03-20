class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.23.0.tar.gz"
  sha256 "46e076f35cd8919a566d595b7fef05ce9c5c223a66bea6ee6dd3092c42697bd1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33164e4a6e2a690ea21c96c08e4ece2c2623bfb9ba7c25d2ca55577b3b5a39f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af52b2748b09e27c7bb728d4846b1a95dbdfd955f2bdef6d06419b5f4ae235a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f495d5ba60af4e49af4cf002012adf23b951b80500f0bc7ab0d31a0c6fee419"
    sha256 cellar: :any_skip_relocation, ventura:        "22693acb2e094ddf21d7bc1937f35dec61cedf048925279bde4e2f866894c052"
    sha256 cellar: :any_skip_relocation, monterey:       "dab58ab3f3f54e190532b5d9140d4226ae556eb7bcc41b272e8d109670515a25"
    sha256 cellar: :any_skip_relocation, big_sur:        "5022468dbb8745ff4e4d107b0ff66ea23f7521cf55cd700a23c0025ad69ebf3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587e08369f838e7c456d2953a19330d5cf71fbc9caeeaf1c289694e713b73020"
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
