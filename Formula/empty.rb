class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.22b/empty-0.6.22b.tgz"
  sha256 "f581d560e1fa857f5304586e3c2107b5838bcf11dedcccec4a7191fa9e261b69"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84afb04ac997310da37e100d6d50f618d1ee1d293ff11694dc2449b6f65a659d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7264818e54338763ddae29e5c468f717072bc7c6a4752c4318da7a8bc5f144a8"
    sha256 cellar: :any_skip_relocation, monterey:       "a7e0b4eecd78ddb0c349b97ab70ad1a8159e3a55b10a5079ba24797fa2933ebd"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05665ea66efb506651fca79d7f7cdd2cc448b598499ed42b08f19c8928bca26"
    sha256 cellar: :any_skip_relocation, catalina:       "5ab09ed653c3f767d333aab559471675d68ee366bbc8a9980ccce0f6a5b2efda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce8354cfcdb62d269eefbe94c06693758f986d1446fea89b569c0021546a734e"
  end

  def install
    # Fix incorrect link order in Linux
    inreplace "Makefile", "${LIBS} -o empty empty.c", "empty.c ${LIBS} -o empty" if OS.linux?

    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    rm_rf "#{prefix}/man"
    man1.install "empty.1"
    pkgshare.install "examples"
  end

  test do
    require "pty"

    # Looks like PTY must be attached for the process to be started
    PTY.spawn(bin/"empty", "-f", "-i", "in", "-o", "out", "-p", "test.pid", "cat") { |_r, _w, pid| Process.wait(pid) }
    system bin/"empty", "-s", "-o", "in", "Hello, world!\n"
    assert_equal "Hello, world!\n", shell_output(bin/"empty -r -i out")

    system bin/"empty", "-k", File.read(testpath/"test.pid")
    sleep 1
    %w[in out test.pid].each { |file| refute_predicate testpath/file, :exist? }
  end
end
