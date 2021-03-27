class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.12.1.tar.gz"
  sha256 "472bd80751158ed5ad72c162f6da0810f19f7f95d193e9858e8cb51a4b54fe8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ab58551c5fe4542ff3f35cb6d60e2837c58cda0408f0a415f5f4ac089c948a3"
    sha256 cellar: :any_skip_relocation, big_sur:       "177f3ab786153b2cbcb28b39425922b08cd30615cf063c957213d49e68011496"
    sha256 cellar: :any_skip_relocation, catalina:      "bef63b785a98fcbef2344999a8f9ae7154835a309190103536859901aa1d8608"
    sha256 cellar: :any_skip_relocation, mojave:        "c430415f1a9db9e193586ef4d1b48eed504d5ee8382334d521a18e0b5384086f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
