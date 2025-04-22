class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "821bdff48a3f683bc4bb3b6f0b5fe7b2d647cf65d52aeb63328c91a6c6df285a"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "977f9c2ad831aed827b3cf8ad38606f64b11b4c1c6a170ecc0a2bf8118911b63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "474df4968035d4949cc7d955302036f3e665d3bc6dc37fd221598bb3e1aef31b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c7814f2fc23794608edce7b86d8dfcf20fd810acbd5a66515f8731aeafd0585"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cf692e5eabf45fee86530ee3313fa68a3942405587606e3ee39cadc781e3ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "e2fa65aa91a9ec6054bf01c693ca4c8a9c086270020c7c281d729dc3a5cef70e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e50a8c0ecd4e893f973b313e213fe3a8dd1ee883ac121ee5204f1f5fd818b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99758937cfb53c0e214a4e752b50d38bf9e32e87ec31c7802b84953a802cbe6c"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    (testpath/"build.ninja").write <<~NINJA
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    NINJA
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
