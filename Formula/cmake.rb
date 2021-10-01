class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  # Keep in sync with cmake-docs.
  url "https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.21.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.21.3.tar.gz"
  sha256 "d14d06df4265134ee42c4d50f5a60cb8b471b7b6a47da8e5d914d49dd783794f"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16378902f233d8570cd0a67a1dd255acabdd29ff84d85e16cdbce68049d1e263"
    sha256 cellar: :any_skip_relocation, big_sur:       "871469119eb1fc5b005971866925259b27960e2105935ad70e934002e429eaa9"
    sha256 cellar: :any_skip_relocation, catalina:      "1cb1c2477f326aff08671d605564b0357a8a26257b9e94f73e44192690b5d241"
    sha256 cellar: :any_skip_relocation, mojave:        "b1745442cd4e9e0c9614ae9dd7d587558af9ba7b438fc22e012d3c1300747b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0cd2bca284489bfcd9ddc1fb0b4323b59679ef837ee4efbf819a8a404a72609"
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
