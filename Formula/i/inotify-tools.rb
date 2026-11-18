class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.287.tar.gz"
  sha256 "d25b7229bccc915db55695a11c9d3a0c3aa6aa385c261297404fffa911e3fd68"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "9323724818634e205bcff1a6ebc3838782ebc0279419c54d2518fd59076e08bc"
    sha256 cellar: :any, x86_64_linux: "39f7522f02a13eba1b5e38b2013a51599823b6330a9fd0a65e54dcf4b6f2ca3d"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Stamp the full version like `make dist` does, as the tarball has no git history
    (buildpath/"VERSION").atomic_write "#{version}\n"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}", "CARGOFLAGS=--locked --offline"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inotifywait --help", 1)

    touch "test.txt"
    stdin, stdout, stderr, = Open3.popen3("#{bin}/inotifywatch test.txt --timeout 2")
    stdin.close
    assert_match "Establishing watches", stderr.read
    stdout.close
    stderr.close
  end
end
