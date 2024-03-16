class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.27.1.tar.gz"
  sha256 "b65580574ca624072b1a94d59ebf201ab664eacacb46a5043ef7b81ebb538f80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e1f54645d0e86e8b2e4f2a829962fc83d2f95feeca16630af236a930534d23e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e80d2d3cb22652242f9283c8189105f0c1f90b05ef2aaab0c1184745d0272edd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10d96d9da732f080867d6015e592c7487f2d62cf18917e4cea60cdf8d3c4cce0"
    sha256 cellar: :any_skip_relocation, sonoma:         "20f6c53707d7ab0072858a3820d7a8fea40c103909a75288b4a388cdb4e68a59"
    sha256 cellar: :any_skip_relocation, ventura:        "42e87a029d0e0e4d4b8dc49463e6b98a15d8de89e7da089d2526f9d74fe84957"
    sha256 cellar: :any_skip_relocation, monterey:       "701a29bcf2132d61fcd33ca6c18d4faaed245671c9abff8afd5844301eb17a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac1d3605b7a3b73c16021a55903a28a7b35e936486592879d128eea224d5c957"
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
