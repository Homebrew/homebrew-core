class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "7120613f966b311d3c7cca888c9f033a48a22edbc7ec4078c3d8dbfd3a327dda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75413f2b6007586d3548576911d6c9f75297afea281674b68c38b5802e3db6dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6185753deae31bfaae583c6dbd3a09da3fb37c74a90d8e1a94f9210e655b5d3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "348b083efe36a8c33b511f2f75691f9b1c6575bfa0570f7eaaaf6a9debb8ae8b"
    sha256 cellar: :any_skip_relocation, monterey:       "ffc384ae8e6cf8bd81bb212d8bcbfc666ab9b1d22f7978f24f69ac357473d348"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae08149471b593dc9f40aaf912ebcc041a3dd2adecc315fe46830fd578f031a8"
    sha256 cellar: :any_skip_relocation, catalina:       "f6e54973a62462e24f92b8f9301bc2c1f752f7fd747fb4b4c66265afd4a0fa0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf9d13ebd118ff652a16fa55158aa1aa3d7d672b2c9c524673f0bd865aee18a5"
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
