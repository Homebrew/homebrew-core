class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "31747ae633213f1eda3842686f83c2aa1412e0f5691d1c14dbbcc67fe7400cea"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ffeafe29b18803d198ec794be40267e6df9384eb485af19197ecf29b61a1451a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f973424d56f32c88d2de08e26d2ab37c9966ab3f0b6ad5e8d36a953e24a1998e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9258efc6ef75aa56f68844ddf48f8ca050a91a45738c6715de73e5a2fe88dccf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293c707dd52fb9136ca3d95f74e63a741a975e4589c0900e9a184bfeb90d0625"
    sha256 cellar: :any_skip_relocation, sonoma:         "0985f9b135ca58e18efe12665d410b08109dd215f087c22d44e02c3779d368d3"
    sha256 cellar: :any_skip_relocation, ventura:        "51b5d6787ffc70b7b5762942c9329d2341afacbc96c3035f5e46ade9b036af7c"
    sha256 cellar: :any_skip_relocation, monterey:       "7083778d561200849c37c7763032f157c66ddfdcd9f2a813a685d1fc90ca2799"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f625fc538dbceeecebb5088bda7b3d2daa8477adb3f9653f01e3eff76983b8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96fe0b239b3add346f8e4e2ea7e0713018f49f03e684e80706fcf4cba7b24fcb"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

  # Fix `source code cannot contain null bytes` for Python 3.11.4+
  # https://github.com/ninja-build/ninja/pull/2311
  patch do
    url "https://github.com/ninja-build/ninja/commit/67834978a6abdfb790dac165b8b1f1c93648e624.patch?full_index=1"
    sha256 "078c7d08278aebff346b0e7490d98f3d147db88ebfa6abf34be615b5f12bdf42"
  end

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
