class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.291.tar.gz"
  sha256 "46b1a5569772011b23f0059330bc46affa8aaaf0ed790edc28114d6c10e690eb"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    manifest_sha256 "6ad7dc75d3d1d68d84e97251f85ebd7a4e5c28496b9a6796d1a3f58f5082ff90"
    sha256 cellar: :any, arm64_linux:  "78136867b3c009d088b2a6acf7f825853e86ea4c8296c4383cc53afd04563b1b"
    sha256 cellar: :any, x86_64_linux: "d01aebbaccdca654e3421d8543ac2166684e1dcccc6c2173dfc49e9fee944c03"
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
