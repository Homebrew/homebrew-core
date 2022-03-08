class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.6.1.tar.gz"
  sha256 "ce14d03a24212ae544ebd7217bc875eaa5fd4396dd11ae06ac707ef4e14c9690"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2008ee74d1261c85447892f0f8e283050ed8a36e4640f43e9c88be4cb1e5a76e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e6dabb70373426844758d1eac54f597cacc159244127546ade02ea6b2a9af12"
    sha256 cellar: :any_skip_relocation, monterey:       "a45a21b9b4f54d53b42d87ffaca641003292a10195bfda880df02f84cbc38617"
    sha256 cellar: :any_skip_relocation, big_sur:        "2006193ff118a6c4cdffef4472b124e16aaa683df9b8c19ef65fb7ef148b9a61"
    sha256 cellar: :any_skip_relocation, catalina:       "a4dfc06080ea27fc9d9f65495db95a472b5bd685f21fc21d0a3cb3a252a5816e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c6fddfcbfde977252e80ac3c55d2a30115a19274afc4cc210371d3445f7c8be"
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
