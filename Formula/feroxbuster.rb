class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.3.3.tar.gz"
  sha256 "5a244d1614fb9dc476e9be8bd1cdbb33e0b07a1fcb7285e911ae6c77a44c7327"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25abcf60520f6a429c8f03bb787c1468e8a9171fdf50dccab787df0fa9ae6c27"
    sha256 cellar: :any_skip_relocation, big_sur:       "f8dfe94cde14ffd5ca38db282738275f871830b600017e7e626415ab2331db07"
    sha256 cellar: :any_skip_relocation, catalina:      "d383a8e59bf8e41d18975cb945eecf2700c3ee201197af8b56aa49f6dc3dc0c2"
    sha256 cellar: :any_skip_relocation, mojave:        "bd6cea2444b6383e0c1a88c61245974d287836c830194209620e8070616c5f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f0c94bac2c217e0b650220fe5dc43ce29a18054763c18a23623d4129d814972"
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
