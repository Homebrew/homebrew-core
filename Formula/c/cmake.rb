class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.9/cmake-3.27.9.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.9.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.9.tar.gz"
  sha256 "609a9b98572a6a5ea477f912cffb973109ed4d0a6a6b3f9e2353d2cdc048708e"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80a9437105ffd83f22d198c0dc1d8b0286624b98699984acb28786a48e6759a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d6d28faa8836dfac755279594499bfe58f59dc8741eeec0c1e34406bbc01228"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1500b3f5af0ca3be0b351069ac605640171046298cdd81ba2de7b2685e138ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d3a22e4c2feb12e2d053388645e073918e225947b1bf346f179f2b93c7ad969"
    sha256 cellar: :any_skip_relocation, ventura:        "1f02122a4727b1583a295bf4ffe74f9db2c3ceba9884d21dbe36ff2860ba961d"
    sha256 cellar: :any_skip_relocation, monterey:       "e43bd27dbb25c9ec69e56a6e85269bd81a5e097968cf4423086457730fbaecb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "700cc2d420e71d867cf1d17cd4fb89f4027feb5191ca3de39b030c0fc5646e85"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # The `with-qt` GUI option was removed due to circular dependencies if
    # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
    # For the GUI application please instead use `brew install --cask cmake`.
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

    # The completions were removed because of problems with system bash
    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
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
