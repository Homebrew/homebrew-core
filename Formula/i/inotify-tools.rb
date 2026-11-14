class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.277.tar.gz"
  sha256 "13a62e1287de19d3553a379c65cf8519d9cb9fc0acb3ac4eadcc13fee686dde0"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "83eaa25de0bd16346a4ceb99f5c6a88c32c5ea3983f9de88c491e78e239051d1"
    sha256 cellar: :any, x86_64_linux: "c862396fa3b1814921a73d15bb3c90f235dbdb78c07247624d97fd457de48f78"
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
