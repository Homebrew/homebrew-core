class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  revision 2
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url "https://github.com/ninja-build/ninja/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "573d01508893add0fadf069f53d6ccc968e93943d1a3e40bf65b4d8ac8ed0a1f" => :catalina
    sha256 "d431b62893122706a8feb184e61c0d5836189e1e2614764540a356ae0a665ed3" => :mojave
    sha256 "d7ea07c919779729613eba445b34aaa0425d505af17ea5bda70dada8ac473ddb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "python@3.8"

  # from https://github.com/ninja-build/ninja/pull/1836, remove in next release
  patch do
    url "https://github.com/ninja-build/ninja/commit/2f3e5275e2ea67cb634488957adbb997c2ff685f.diff?full_index=1"
    sha256 "aee7a3e862c8ded377e4a948390519bc7ff17cae69ae779d3c5172562d9559f2"
  end

  def install
    inreplace "CMakeLists.txt", 'NINJA_PYTHON="python"', "NINJA_PYTHON=\"#{Formula["python@3.8"].opt_bin}/python3\""

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
