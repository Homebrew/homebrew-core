class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.5.0.tar.gz"
  sha256 "26684c4945e5a19ee44ef374f582354c520823581c9c3d9a3881cfe28b09b479"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c2bf23e62cc1d0f65fa87983465d7c0c8dafee9e8f142fe4ede3d1f4eae4140"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d4427700118c76acf7fb44519b91ab41b238c4136e3af6d17ca9ce283d90907"
    sha256 cellar: :any_skip_relocation, monterey:       "0c5fa7ce14b2fc55b56d0b3d92dd75ed9e5a84f238b85a270685f36f268a77f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f0179c25a809d122275fd5ef484dde88ed48ddc3b74a2860a5538294c0fd2aa"
    sha256 cellar: :any_skip_relocation, catalina:       "ae24ebd24af4d45a16817ce3a013ca91845719adc4a7f624d3bfbd77904b26b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78ba190a7b83fb99f3504630b956bb4c1e0e80e2f3cf38a4ae807e8937c619f3"
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
