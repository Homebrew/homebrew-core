class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz"
  sha256 "ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ba394fee0825079adf179dfaebd6d38ac3e4918d851f3e844b52bdd6a97b12b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a024937b955212892b810dbe09af351b8966448cab497db3d81cd6ca829cd8ec"
    sha256 cellar: :any_skip_relocation, catalina:      "07ce960dd5c57859916a09090ef9b747a28c56892d60cc91c29b85c8cc13d902"
    sha256 cellar: :any_skip_relocation, mojave:        "b9c82b12477142c1a4ed7d030d9227b6c351fbe7747f3533e37607e5497db22b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8668b179edcaf6f918dbd83aea05c421015c46c546a9b0744b5c723a2737d55"
  end

  # Ninja only needs Python for some non-core functionality.
  depends_on "python@3.9" => [:build, :test]

  def install
    py = Formula["python@3.9"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=python3"

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
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--no-browser", "foo.o"
    end
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://localhost:#{port}?foo.o")
  end
end
