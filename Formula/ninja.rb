class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  revision 3
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url "https://github.com/ninja-build/ninja/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "e7bf290104b821c1bc54a3f20f17c6ead05704130c92b6438ca85cc52f7027b8" => :catalina
    sha256 "aa9821c77bc31e22b8abde346c787353b53c1b092b7c16a5fcefc9d64c97e6ed" => :mojave
    sha256 "a7a30267288572d960f0d213b941076e6740f6b89c65447ae6c8d41fa3752480" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.9"

  # from https://github.com/ninja-build/ninja/pull/1836, remove in next release
  patch do
    url "https://github.com/ninja-build/ninja/commit/2f3e5275e2ea67cb634488957adbb997c2ff685f.patch?full_index=1"
    sha256 "77e96405d6f2d4dbeee07b07186b5963257573fd470894a1ed78e5e6a288e5eb"
  end

  def install
    inreplace "CMakeLists.txt", 'NINJA_PYTHON="python"', "NINJA_PYTHON=\"#{Formula["python@3.9"].opt_bin}/python3\""

    system "cmake", "-Bbuild-cmake", "-H.", *std_cmake_args
    system "cmake", "--build", "build-cmake"

    # Quickly test the build
    system "./build-cmake/ninja_test"

    bin.install "build-cmake/ninja"
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
