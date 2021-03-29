class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.13.0.tar.gz"
  sha256 "3578fd2dfe8dbebecd15b1e82cfb6d6656fed5e54ae4fccc4e7a6879b61dd1e1"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "42d87b45cbb447afb5a429878eebfa980a8b984ecd2bf772127973525e401d48"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbb33d3dcaa6d38fcdf4b03d1b2f3e0d8c6d62590ce92e1f901b80f1762b8e61"
    sha256 cellar: :any_skip_relocation, catalina:      "533624f68a716082ce79a5dd00af61b155875903a934682f6c21e8d30d28300d"
    sha256 cellar: :any_skip_relocation, mojave:        "9afb3d1162882e3f4c47ed8d61b8d232fa0ce0b769bb701a9b70570b780ec97b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "bash")
    (bash_completion/"miniserve").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "zsh")
    (zsh_completion/"_miniserve").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/miniserve", "--print-completions", "fish")
    (fish_completion/"miniserve.fish").write fish_output
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
