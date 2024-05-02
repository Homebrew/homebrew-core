class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.10.3.tar.gz"
  sha256 "ce4eae833118456a575f1b2839639b901632d33c5cc18085dfc47e8f68749618"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fad313e245481eae84454f276b0403be4bfabbc37d7aae4cf639697556ff9cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf1a6df8ab0a625fe3750035ff75ec8a4165fa1a91688aeeb4b32bc81cbbd53c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ce200b5940bb04e615bd8360e7c400bfad24143afe85d8ce73e518192641427"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf2c0c56cd6d2d852227c77b3c23cb786c9f46e6a08307b2849d020a2b0b1c1a"
    sha256 cellar: :any_skip_relocation, ventura:        "25751ed6b39b5feee4398cd20bcd0107fc973387dd96a7a054f1300cc39ed9e3"
    sha256 cellar: :any_skip_relocation, monterey:       "3c66d46fe048bb6a52983aa17c53e3c290cc6e5cd2be68e3b70065721af146f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc3a0c3ec7bad7ddadbf1dab84d0ca4742cad8f826ab663d6dd766cf906b0fb7"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "miniserve" => :test
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
