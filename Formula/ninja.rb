class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.8.2.tar.gz"
  sha256 "86b8700c3d0880c2b44c2ff67ce42774aaf8c28cbf57725cb881569288c1c6f4"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2faaa515a471f3aa443a74599da1b3112772b8af46458599389e0cd26e79e417" => :high_sierra
    sha256 "a01d44b0a8af3445a6a1e6cd01c81648c6b445119fbae51a54c634d77cbd7f2e" => :sierra
    sha256 "1973a5e00cf2bc5a13597f979e3bb7a56d3a1ad12b2073b5b5b4368a58335e65" => :el_capitan
    sha256 "60dc23e5cc3a940d38f4c0914e0fd2eac2f30222270c95d34b9f1a6b152844ba" => :yosemite
  end

  option "without-test", "Don't run build-time tests"

  deprecated_option "without-tests" => "without-test"

  resource "gtest" do
    url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/googletest/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  def install
    system "python", "configure.py", "--bootstrap"

    if build.with? "test"
      (buildpath/"gtest").install resource("gtest")
      system "./configure.py", "--with-gtest=gtest"
      system "./ninja", "ninja_test"
      system "./ninja_test", "--gtest_filter=-SubprocessTest.SetWithLots"
    end

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
  end

  test do
    (testpath/"build.ninja").write <<-EOS.undent
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
  end
end
