class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://martine.github.io/ninja/"
  url "https://github.com/ninja-build/ninja/archive/v1.7.1.tar.gz"
  sha256 "51581de53cf4705b89eb6b14a85baa73288ad08bff256e7d30d529155813be19"
  head "https://github.com/martine/ninja.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "facfca510094c956257dbffd94719139eb7a8f7ad8362d4064638c753268b6fe" => :el_capitan
    sha256 "827e1ce721bd8c95fea9093b74fa5c9d9b5aa0e2660241b44b5f5233833c58f0" => :yosemite
    sha256 "7a8da38c247855e12054ea7dc8ca8796be19151a2683fcaf50772780d122e90a" => :mavericks
    sha256 "3717352656bb260ac96de4a0db856ebaa6602c6b4f4d42a0d2475ba511ab834f" => :mountain_lion
  end

  option "without-test", "Don't run build-time tests"

  deprecated_option "without-tests" => "without-test"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
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
