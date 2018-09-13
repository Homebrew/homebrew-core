class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.8.2.tar.gz"
  sha256 "86b8700c3d0880c2b44c2ff67ce42774aaf8c28cbf57725cb881569288c1c6f4"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b40a7da5db26b6bb32537185bd79861cce13f723cc02ad503e8501b6fca2d6f4" => :mojave
    sha256 "eeba4fff08b3ed4b308250fb650f7d06630acd18465900ba0e27cecfe925a6cc" => :high_sierra
    sha256 "90ecf90948f0fa65c82011d79338d7c5ca2a4d0cb7cb8dc3892243f749fbe2eb" => :sierra
    sha256 "675165ce642fa811e1a0a363be0ba66a7b907d46056f89fd20938aa33e7d59f7" => :el_capitan
  end

  def install
    system "python", "configure.py", "--bootstrap"

    # Quickly test the build
    system "./configure.py"
    system "./ninja", "ninja_test"
    system "./ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
  end
end
