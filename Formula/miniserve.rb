class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/v0.23.1.tar.gz"
  sha256 "2812e5f700612576587a76ba5ea51a3eb7f60b1dd1b580cd9a015ad2feac5b8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00fd4a079cc6f42a9dfc71e512ccbe2a0cf7ef9d5404d07bcf7e5b0ce7460ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3670468248fc297364874657711f6b779f862173ab86dd1093296a0238c7ae4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c72d5b133fe805d68fe612f93f70ed8acc8e74d09345937c9f3c3805bdee4eda"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d22754bb4cb341c1f6bdff98573a5d8a446ee888932146cb9b6283c743bbdc"
    sha256 cellar: :any_skip_relocation, monterey:       "640bd3cf2848da2de6b10ebb8b413261bf08875fbc7729717225958ce549d04d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4538e629e38c776eea0e145c7eab807ec1d3c57dcd9bb5c520bc14fa6289ce01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6244d23e66c9e300194025fc0f277b32f0d37db3250938a8d054c19cd47d909"
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
