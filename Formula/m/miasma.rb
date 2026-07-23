class Miasma < Formula
  desc "Trap AI web scrapers in an endless poison pit"
  homepage "https://github.com/austin-weeks/miasma"
  url "https://github.com/austin-weeks/miasma/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "512620fa84d4d95efa73bdc3223928eec8b200dcd6ebf91fd1a9ae62cfbc7ec5"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1a15d7d8eed14060b1cbabcd8d3acb6cbd0ccff83162e4e8079a38793ad39f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210463fac715b51e831bff9c2023a597cc0968d3b234fda56b3d1d92797995cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5b77cc9f7d379b53d78d8f8c752925bcb473b012137ae21607524ed8316b6f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd2e3433032f223707be41a3371dc0fcd6c5d28e0e64c5eacd3c5fd50890e7c2"
    sha256 cellar: :any,                 arm64_linux:   "89dd45916655f7571fcc75c093db62ea0813c631ea19b4b2496a395d21717d66"
    sha256 cellar: :any,                 x86_64_linux:  "b604326f74f7887b2e7fdf05ab3e1dadd6f1e32614b67d8e6f53198724596cf5"
  end

  depends_on "rust" => :build

  uses_from_macos "sqlite"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = spawn bin/"miasma", "--host", "127.0.0.1", "--port", port.to_s

    # give the server a second to start up
    sleep 3
    system "curl", "-sSf", "http://127.0.0.1:#{port}/"
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
