class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.0/cmake-3.22.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.0.tar.gz"
  sha256 "998c7ba34778d2dfdb3df8a695469e24b11e2bfa21fbe41b361a3f45e1c9345e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c86a0bb0e37c293e2d4475519d28f2784c430e871f74969a1a2afeb64b540a7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86199f003e396fc43d483dfae6322be8aad0a8b3a6501bb20af916a60027a78f"
    sha256 cellar: :any_skip_relocation, monterey:       "d6fb0df5818454f9f9074552eb06c34146da91c5212c16057b544a3677a29d9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7170cb38b7eae4e2b115824984cef98e004366c5910fe7cee189a62dac58d13"
    sha256 cellar: :any_skip_relocation, catalina:       "2dde258f7e2f20077c79996d0c14a3899b3aa9db34f57ad9aa96d420172fbd80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13702d526428c2f42074567af2730c649eb76da686cc22c3a2b5ef7c4464d845"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
