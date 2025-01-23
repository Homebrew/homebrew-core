class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.23c/empty-0.6.23c.tgz"
  sha256 "8a7ca8c7099dc6d6743ac7eafc0be3b1f8991d2c8f20cf66ce900c7f08e010bd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c189f046cac1c33a86463305d78c4a6b69233414cf539b9ec3b65a13c348b970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0e6d00eaaefbe6a60857ff4a530fb8d28bc5f620ec8716d26c16071c2ecc5f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b22f16579a729968596b00989f62625dd4c9bbcc80b087057f5cfd5d2ecffef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85ab1fd9a6ed43ce5d9ad0172d4fe9e62b1f52162e2b99ff7a60fd9d17007511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed303027d0ffbeaa26261bc64f0ccc440d8765d38044dbdd5c9885aac4442a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba9e403002ccb197f4789d6a654214980010c94999133142c8f787dfaefccbaa"
    sha256 cellar: :any_skip_relocation, ventura:        "3fb2717f273099d9011d8382c033afe8d6b7836dc2223b1ac3a301b683a0aea3"
    sha256 cellar: :any_skip_relocation, monterey:       "6ba9bd7cdb7d47260f1c5dc600e93514c2222f7b3e5aab9a2ff5dbcadbf81d13"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8de713e95fe5ac8ffdb15ea679106b41ed858d70d7a96250b9694cfee4fb855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3eeb73345dc8be3472ece5c28260e9592b6acf8cc6bb50abba43376cb10404"
  end

  def install
    # Fix incorrect link order in Linux
    inreplace "Makefile", "${LIBS} -o empty empty.c", "empty.c ${LIBS} -o empty" if OS.linux?

    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    rm_r("#{prefix}/man")
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
