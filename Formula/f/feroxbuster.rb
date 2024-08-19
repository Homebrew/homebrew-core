class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "6eea0602971de78fe24b5c93c1985e57e0b8cb5a8f3a05688d2465e96b27329c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "deb6a5f5e0d086c3b48694f1f571036a07265e21a94af1610e90cdc9cfc783bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bd32781603abaafa34c092cf83681779d7fdc18f5fdf2217fbe1c840793f4ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f1f11691218e38df06fc75788693b75c76893a42c9a8d4e0801bd42d383cda5"
    sha256 cellar: :any_skip_relocation, sonoma:         "2c0542e745b92048e6b0f46588f07176abb2f604b4c8608b939fe624c4ca43ee"
    sha256 cellar: :any_skip_relocation, ventura:        "1a0c17f47377b4d28ef3b937623fc043ad6f156374fd3872eba02bb84bea865b"
    sha256 cellar: :any_skip_relocation, monterey:       "ea383abecb20d6e7473f026acd5f88b6def15a1c65d8c3d44c501d4b98d82e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16bda01bb5093d778bb252c297ac77adadf53b8ae7e4a151f551b2318ce81fe"
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
