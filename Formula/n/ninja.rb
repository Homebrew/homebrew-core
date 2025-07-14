class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "f0055ad0369bf2e372955ba55128d000cfcc21777057806015b45e4accbebf23"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "873e06703ff0d22140b1683b6272b65a57a3e87b506b7904ad82b6018df6db06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8958969cfa17f656280e7bb08bdcc71d657b3208a786c012041f53bb455d96ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8001e8a0a4ff7ca04fe84d366a02f981a4916f794f43ce5594dedbb4f5fc297f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca928abda16bab3735437ec593eebf85947f3b8aba1b90ee024cce0d9ee9428d"
    sha256 cellar: :any_skip_relocation, ventura:       "3f7c0ce43b98aa2f1c6a30cf14043abb4a739c5675a46a662d158fe65b7a8ade"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9861ae88dd629add0d88046028c24240d48d57f5ee31c1b0922996221176250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13cca961d30a825d800c714dfc04932d916b08127ac866c37fc99a7072e22003"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
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
