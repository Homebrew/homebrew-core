class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz"
  sha256 "ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "e5e8174fb4bce324cfb42226d46ce1433f34866f0c06ce930a3bbdb40cadd395" => :big_sur
    sha256 "8be5a50d0bfe6bae6f920def1273bc0da888a5eef7304303888b1a5929bd517e" => :arm64_big_sur
    sha256 "5eb553057f7595f0c607b100ac263ab5834a057b11e8aca512555f5129f6d544" => :catalina
    sha256 "8d7775944ef67e3f8884bff5ea0013a80c4811be8c268fdd9b37cc377eb9ec1b" => :mojave
  end

  depends_on "python@3.9"

  def install
    py = Formula["python@3.9"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=#{py}"

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
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--no-browser", "foo.o"
    end
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://localhost:#{port}?foo.o")
  end
end
