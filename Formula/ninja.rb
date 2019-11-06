class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.9.0.tar.gz"
  sha256 "5d7ec75828f8d3fd1a0c2f31b5b0cea780cdfe1031359228c428c1a48bfcd5b9"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9cfd9fe284e4c4eda7bda2a7a5c3970b22775df472a57e7aafea12a36b69357f" => :catalina
    sha256 "d3f825237b23175d46ed02f492df8297968f3ce45f328362f167caf962323c98" => :mojave
    sha256 "c6057431959eb3117f5eca1bb62d2403d189f3091f2cacaef89c9696b2ecec39" => :high_sierra
    sha256 "dc8bba938426720e0f4f2158b882f331737059919cf46ff59fcb786261b8ea8c" => :sierra
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
