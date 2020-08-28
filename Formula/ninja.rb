class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url "https://github.com/ninja-build/ninja/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d43c3811eef40b2ed82f7629a3cb8acab313f8459778e506de39d95b3cd0e5e3" => :catalina
    sha256 "b8a22ed5d7a0138d04e29d616e11c55d85733b7062911a8f0d9e1c4405cc4f61" => :mojave
    sha256 "8070023444b46cc29d7e52b71cdda279c4734d96d29c7785302ae0ffe27b1245" => :high_sierra
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
