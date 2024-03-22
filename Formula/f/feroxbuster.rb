class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.10.2.tar.gz"
  sha256 "c73d26f21431c5dad77b6910471f768df5b27d5486b276f328f2d370d1c57003"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6d1ef665eddbad1a89e9fbb8cf066694b410726f591bb11615ea456c1ff43a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c64eaec6765bc9413e7d1db2d5ef37c92ba9d91786bed337c5828d14430340b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdef706d68c0771251418d3c63e6701b53a03aec98eeb255b327402ab16b8509"
    sha256 cellar: :any_skip_relocation, sonoma:         "35eb32ffb62b4f9c846871f52341dc1ccf3f43aa33f7297d76aaf5af5f58ff93"
    sha256 cellar: :any_skip_relocation, ventura:        "16eb1bd6d427d9bac449ff3686b44b694097e978dac4cd66221fe18ce13e4e9b"
    sha256 cellar: :any_skip_relocation, monterey:       "855c37a904eb953b4f2730619c16d0201451857e4be19de34ef5fd065e620821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940658785b8c3a454e6b71ff0e2c555f733e7ce3bb5f8b6d84cfc62ef7b6f1a7"
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
