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
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4ccb687bdd51f132eb4e87bda877c7ec7fbd565dd567c59e074083977c7e027b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0137a7ca41103118431134051e264a38dfcfd90a1d23354527dec7ecd4098d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee3cb1d64ad324420cb83866236159703faa91825353d4f2ac70aa8a729d03f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4853917b940c67e971ecc4575d490080e88ea812b1af2e9f3b383c5f9012f9eb"
    sha256 cellar: :any_skip_relocation, sequoia:        "8b078ad9df50b80bd296614204d1dc0a42e9340edd45d0aa0c6576cd538be50f"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9e7f5d59c29882398cbf1cf9fcf358db480afa96ad9fb51a87aa0da9b5fabd7"
    sha256 cellar: :any_skip_relocation, ventura:        "4cda186dde7fff9284bc64d2469faf3a6af148e656f9ee9c27d731d1e02bb637"
    sha256 cellar: :any_skip_relocation, monterey:       "ef5eced95e4a700b49d67acdf1fa25547242ca95e36ed197339dc24f5239c312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1fdec103d46cf08a086a70f0c4bda35927cfdfcef35bad0da2b0b4430c8801"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

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
