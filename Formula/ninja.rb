class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.11.0.tar.gz"
  sha256 "3c6ba2e66400fe3f1ae83deb4b235faf3137ec20bd5b08c29bfc368db143e4c6"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46cdad783a36c60dcce23b8a1857e54dd0e3935f30ec4586596bad81c1b1c347"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b87214797b286ee46413e9099f686bba663ea838cb688f2a59e4fc48b9c2a7e"
    sha256 cellar: :any_skip_relocation, monterey:       "61f5f9c72b75a42e1f44a47932e476a1602594a8fe8e27a3dd73d89f4c356e8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "99b7e8cf83eb6eda1e6c787eb970a67df2725a67e5c476c85172ed6c5701f32a"
    sha256 cellar: :any_skip_relocation, catalina:       "cdd5ba34ff65ec225548bd872dd775bc29fb4ae3994a2a4629d367dfb02eff2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "745d1eb8dea681f16692b2dcdcb9e464547bb5d9c84e78b177898405421bc82b"
  end

  # Ninja only needs Python for some non-core functionality.
  depends_on "python@3.10" => [:build, :test]

  def install
    py = Formula["python@3.10"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_bin
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
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
