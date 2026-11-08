class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.275.tar.gz"
  sha256 "11bba75bafb28d872ee91d0c36b0f8a015fcbc3ce0f8d3275445c95d26e04b81"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_linux:  "3d0e752a1520bcc4637b60ae69016cb819dc593c0ab10c3a08b511df58f920cd"
    sha256 cellar: :any, x86_64_linux: "d3faf88ce52d76991f164b88ab90576262648d79560807e0ae7d71905d333913"
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
