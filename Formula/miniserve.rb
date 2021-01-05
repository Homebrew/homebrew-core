class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.10.4.tar.gz"
  sha256 "03b8549258deb17759d69ad73047429f8420e3eab7588af086caf14e47c96332"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "360d6a2c155008807a600f6918d102c18e4189fd22e1b3e951df61b1a26af785" => :big_sur
    sha256 "15f3fd501ad3a1224029634aa130abb09d1ef15349d7974363d30fe3dda96e6c" => :arm64_big_sur
    sha256 "5aecd4dd080d29cbdc19c9364d0f258dab2c0b949d91f7e1476c04815b1efe04" => :catalina
    sha256 "a1ad84a40334855440f7a05815a6824c6ee300fadaa6324be156057b2ee04d60" => :mojave
    sha256 "3c004b4741d5b70faa4d77dc560b7416027a5dc5af4fcca54baaa559946571a5" => :high_sierra
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
