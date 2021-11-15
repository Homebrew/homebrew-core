class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz"
  sha256 "ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8efac5a9c8b7028f64f5a092eb029ff40887b9895fe4235e3fb8bade6a24cada"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2dc001768f9e52e1f5dc30c97e8c18e3b9711075ea68890a74adb4b4a5f2551"
    sha256 cellar: :any_skip_relocation, monterey:       "7a28d090cbec60072c3df5c35be0fa45761d18ce06567120951aa0ded80ff72d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3e0b14cffa2d227c0b4140c1a3742a2a4e7e3966a429e1d253b0e29acfb6293"
    sha256 cellar: :any_skip_relocation, catalina:       "11c2a3cf1cd415a81ff7206f48b77dbe851b593bd163979dfdcb11266d24307a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3837361ee7a7d2646a84db1aee70fff51f957c573e0c7a61b04a91f1ce1ae24"
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
