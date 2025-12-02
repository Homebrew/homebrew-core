class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.23d/empty-0.6.23d.tgz"
  sha256 "9ad495d52b942e3fd858643536d8d12e282568214300954d4518d8c22b893585"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e5c98a10342c451a8b3132ed20b2f4ea156dd075fa553d9af40798fd5f47af7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5528963e58f7075c3d661672120c3af66b0c63b4f8ff744171659e866af291ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1acf68a7237d8e9f33180c12a49a2285af79a35d834e94145da0134bb04e51ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3dce887503bcd7e7cc8cc0ba081bc9cb92bd6ba67ef5f4050c1a4800924c2b7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "802e27a0ba7fafa78a3edfffffc609459738e98f50bb5eb9d1c312da636d7ad0"
    sha256 cellar: :any_skip_relocation, ventura:       "9a0fa642d52265c62f880bc103bcf9417e2efef638347c82ae62c4b8ff022125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79d9126210c74a702eaa3c6d5a375053b218bdcee19b6a3bb491c6042af16552"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0a948757c10df171941b8b0bcd8546a9fdc1ab13b66817e80a21829e632c003"
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
    assert_equal "Hello, world!\n", shell_output("#{bin}/empty -r -i out")

    system bin/"empty", "-k", File.read(testpath/"test.pid")
    sleep 1
    %w[in out test.pid].each { |file| refute_path_exists testpath/file }
  end
end
