class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "974d6b2f4eeefa25625d34da3cb36bdcebe7fbce40f4c16ac0835fd1c0cbae17"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "efc5badad160831eb4bbdfd252a9cc9184e0fa901968b72e6e4f93f67a4c2057"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7bb261a70d9337d765956329580e10f16a0d1ea4eef5a106db39c9e1f8917f00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2c07378c1ccb6cfde4bc2e12877c9f365b31c62ddc4ec631421cb80e3a7e1f11"
    sha256 cellar: :any,                 arm64_linux:       "eff57ad5bb5055d8a76e10950ae9440203b3d902e17f6c5aa0a41d4ffaa15d52"
    sha256 cellar: :any,                 x86_64_linux:      "e924537f9c4efbf55741478c15af88fd38b6a014cc6d124f0dbdabd52611f482"
  end

  uses_from_macos "python" => [:build, :test]

  # runs a server in the test
  allow_network_access! :test

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
    spawn bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    assert_match "foo.c", shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{port}?foo.o")
  end
end
