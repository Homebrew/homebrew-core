class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "94048f360092ae2bea5a7b4a1c642432eec2a6aeb76a7d66aa2cafb909f43bc9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1198304d8c8c6d8b36d924ca8fc28fc117f215c3393974feb1c184d882ee4a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9e83d56031d29cda58979fcb66339de7539905a54190841fdbdaba8e1dfd4f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "976dc1c5e91df9d70ec5d76ec8212b6e4c56da17f67101ad187fa19edf53b150"
    sha256 cellar: :any_skip_relocation, ventura:        "fe192d10c551882ddd1dc1ae266af0f4e005b5c5c5997fe4098bfa4a9a04d68a"
    sha256 cellar: :any_skip_relocation, monterey:       "8220cba0e44d54da241626b93bad99c77c72f422a1372d3df6857f53cf35feae"
    sha256 cellar: :any_skip_relocation, big_sur:        "1403740ab7dbf9cc4e69ca3eeda55c42e54cfe129016242a1eaac3aebc2a957d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41d0b4889102f62263b8ac0d6d6aff462243ba63102cfca49b3bb7a8c4de9c51"
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
