class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz"
  sha256 "51581de53cf4705b89eb6b14a85baa73288ad08bff256e7d30d529155813be19"
  head "https://github.com/ninja-build/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb3550493e570f24379007bfd6012eef1aaf82c739662f02aef0c907031326dc" => :el_capitan
    sha256 "6beefb141b4e39c64a9a42c59acef74c4010b31f67f0696d2e62fa454a959ae9" => :yosemite
    sha256 "3d9341568fbf3d01b5b851d9697623f818d86c425bdbfa7b69db1474fd611d5c" => :mavericks
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
