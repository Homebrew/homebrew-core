class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.1.tar.gz"
  sha256 "a6b6f7ac360d4aabd54e299cc1d8fa7b234cd81b9401693da21221c62569a23e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/ninja-build/ninja.git"

  livecheck do
    url "https://github.com/ninja-build/ninja/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3269729bfc2139757eba003ac7caa7664c355ddb6856c0b0b94fe1d05918da3c" => :catalina
    sha256 "643b9539ddec245f960156a4ddc54c82bb0cf46c2cfc94065737481ec61a705a" => :mojave
    sha256 "5c9a9675b27740d6d4b895a4b5462341593e11f8d2c1ec783e75b956052d7f82" => :high_sierra
  end

  depends_on "cmake" => :build

  # from https://github.com/ninja-build/ninja/pull/1836, remove in next release
  patch do
    url "https://github.com/ninja-build/ninja/commit/2f3e5275e2ea67cb634488957adbb997c2ff685f.diff?full_index=1"
    sha256 "aee7a3e862c8ded377e4a948390519bc7ff17cae69ae779d3c5172562d9559f2"
  end

  def install
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
