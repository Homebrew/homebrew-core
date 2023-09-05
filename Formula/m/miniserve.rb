class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.24.0.tar.gz"
  sha256 "ed0619bfbad3f9ea635aa266a9c4e96247ad94683d50743f0464f48f9e48ae88"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f1e8c5fcef4ffa4c4dab44897542c4d9eef5adb9934402e29ddfb31585a7c19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5683a1a1d809cbb4451a658e455f53a7fd46f4618210319924fee7847c143e01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59dbf3c56ca993da67b46e546e57b0dd122de3fd52582523ef11b9680cc91856"
    sha256 cellar: :any_skip_relocation, ventura:        "bc95fff0bd91a853a0403e38bfc498f3fa5ae94e03a592d3692df3035170567c"
    sha256 cellar: :any_skip_relocation, monterey:       "8733c71e2feb2472a0cab6a5f1e3bd8eefca951d80938778abfc3e7760b0f24c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4609872ffc2855603525af721bdf24b99a3319a02119aa9e80c792d0bf78383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "174134cc5de910a9840a7b080e773760579c6a92af6519daeb37f7a8173123f6"
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
