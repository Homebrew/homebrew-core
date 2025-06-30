class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "a4773ae5a6fbc45baf15a5dcb54fd6b7e0151f2fde25c26ddafc0f95b7d26c32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fa670597db1241a9a10e7426aac8cce9faa8a0608a756073485b0348e977329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7cd1099ca626b285d7079383f7558b50253c0c767c58ce994a2ce63ad68a37a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "76745540d42d6898b2ed36d3dcef7e24a4db959b30d46f3d77e47f667588ec7f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea8b4e5980907b378077175cca05c0cbc3b3bb06198eb66d2905a3e94717bf47"
    sha256 cellar: :any_skip_relocation, ventura:       "17349671b580a68e6a20bc0adb271269e11c0a7b1fe76d8cf29cdfe16dce332b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "748850013ce077b05dab37b7e9e526118135e494c2d64bad2591f27528a60bd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b9fa7e693b64614603fa886d593ed05f489e0547d53a08e9733a6df0c706cf8"
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
