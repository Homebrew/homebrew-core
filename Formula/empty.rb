class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.21b/empty-0.6.21b.tgz"
  sha256 "2fccd0faa1b3deaec1add679cbde3f34250e45872ad5df463badd4bb4edeb797"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf2f0dabd46de8bef94154d66dfab1b9650097e92d92126b572fb7acd894764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b330bcc238599680bc706db6b9f5a2947ad46c60196afce716811ccd2deb0ce0"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a02c5a6c5cb8973346e2f70326eb90d078900fa9da930164276cf9d9052c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33747b4b2d1fc4e3fcfd35471c283e64c60c6cf6d558c6783d7a076cb84e233"
    sha256 cellar: :any_skip_relocation, catalina:       "8eac558272ccf2338a374ea2e7158a4b0cf9008cc0111fefa8c85a80cfab2ee1"
    sha256 cellar: :any_skip_relocation, mojave:         "8fb4ab0e88893f107afe0e69a48ed6f257a11b370bd56b2237ecadec771e1a17"
    sha256 cellar: :any_skip_relocation, high_sierra:    "3c5daa156ad925469841f360ca2687011a96086f7d6c5b8af0fedea97ee059ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbe3a154fe8d74f1f47499dd6abd381523b947385ede6152e82581e37f010fef"
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
