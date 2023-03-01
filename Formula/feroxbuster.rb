class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "23969a3152666f7183d88c404fee59175a88969780115ca37224723c69baa56b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab9abae35a450b728e8c16039fc97f768684cce6bc65dc1c0155f2b20722f851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a0849c3b196f44e8e2241b63adb72125acebaa70d5ff8d5ad463e3c3bb658e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "617974f072d85d78744fea29739f5b3cd655195dfd4c52332608cca1a65100a4"
    sha256 cellar: :any_skip_relocation, ventura:        "348d2dcf82aa0ee60f290ae83d9a873ed351686a98c651fe6d0ef68b72aa881e"
    sha256 cellar: :any_skip_relocation, monterey:       "d0ec01c0e8f3b49726829fdb1e1e06ce337614d8fc3e92d024cb35d2fc7ee672"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b533d83c4bc0f6cbac44805895a737c2d078c379eeb48b97169181f3b249c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9a3e4b6c486073cb9a55e8ee27b6a077f865a542f92002f6afe7d0f804f2e3"
  end

  depends_on "rust" => :build
  depends_on "miniserve" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wordlist").write <<~EOS
      a.txt
      b.txt
    EOS

    (testpath/"web").mkpath
    (testpath/"web/a.txt").write "a"
    (testpath/"web/b.txt").write "b"

    port = free_port
    pid = fork do
      exec "miniserve", testpath/"web", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 1

    begin
      exec bin/"feroxbuster", "-q", "-w", testpath/"wordlist", "-u", "http://127.0.0.1:#{port}"
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
