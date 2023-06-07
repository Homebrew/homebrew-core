class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.11.1.tar.gz"
  sha256 "31747ae633213f1eda3842686f83c2aa1412e0f5691d1c14dbbcc67fe7400cea"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6202ee2d9cdb003e70bd93acca07a070eb9145f0a2fe658d22ffd8119260b4bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa36dfde4c007ccbc92a7b011fb21f475619ee72ee7b9fe4e287bbf69febcc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f6aeafb7814bf2a89527aae69ae64f47fd699c8bf0b5a4213a81d3fc01ff9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "5ed5c0e37faba8d07715936ca1f213d4c39de915aa4a2ec94fde9cfc74f30c15"
    sha256 cellar: :any_skip_relocation, monterey:       "15b65736bfc5c619019cabb2c0f36f2b02a031de9a8bd6c148eba0f329e907bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ebce34e727724d140fb8c22ae3ac845c1c9e61339dc0f5a5ee13d7a04780a5e"
    sha256 cellar: :any_skip_relocation, catalina:       "3e89d7587da0c026f88aec5490582522f9fbfee0bd0e13d1bb773724aee84c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0124cfd2fc96edec66111ffd30f51fa02be75e01a4b930bab17c8e980b28d14"
  end

  # Ninja only needs Python for some non-core functionality.
  depends_on "python@3.11" => :build
  uses_from_macos "python" => :test, since: :catalina

  def install
    system "python3.11", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

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
