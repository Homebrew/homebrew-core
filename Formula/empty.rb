class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.23b/empty-0.6.23b.tgz"
  sha256 "4c4f59c79871e3cc6cb14e80c1fa51b5102997ce67d6e7ba20dcd2d87bd67dea"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c60060363578bbc4c4b1b600a0ce1d5a958c6eb31272eea59fd3682c18249501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2155aa84047d0475aad3f33fc84e529b60ee4f3eb30ba961fbd9533097790f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d00a36d86944fd2f698f528576d07c3fd29c4f47d8a239847f4dac178218ffe"
    sha256 cellar: :any_skip_relocation, ventura:        "c2f7e353dc93713bc246ad169efbe832da9c3b5b908dcc15acc181bff5f1e9a3"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d57578a8d68cb1b7617e04af660276134495fd585d216726ba5aa482800caa"
    sha256 cellar: :any_skip_relocation, big_sur:        "938ee60922f6f982d63e7fe4e49c48dff7e68e1da18dd11f8f21c74a470aaf6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c3bde7cd47380f6ddc81f5f1d6ff1f334584fc9c2f8943f31c48f1209059e3"
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
