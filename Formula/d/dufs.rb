class Dufs < Formula
  desc "Static file server"
  homepage "https://github.com/sigoden/dufs"
  url "https://github.com/sigoden/dufs/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "0e98626461e20c3fb16689a14ea2847a47caa0cdb2405814ad30cd5c9d1b64a1"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a207952b4e6323456d45f3098a2efec79d425aa2a967f88e9ceffdb3b39f5bd3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8030d3849b1a53114fd4049abc81c8d62c11741522020306441c0eef2454264d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aa1f82b68c5b948cb1ee83201d7950fe1b75370409542c5c1e7347e7532ed29"
    sha256 cellar: :any_skip_relocation, ventura:        "d0368f2342b0e9b6e4ca7e0e2da5d812df8fda5ae6de7e6da97e393fe64af825"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b02d17b8f70eafba3ef225c3a46c2b4ffdd43d34bfb1d570c1ccc238549ef7"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbb077dd9d43de68978ada8160f8f0715f704733d8a27927c769a3483265bd17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa7b63ba425fd29d982d66bd957006eb311ab61f154777aaf182fec752875d12"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dufs", "--completions")
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/dufs", bin.to_s, "-b", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"dufs").read
      assert_equal read, shell_output("curl localhost:#{port}/dufs")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
