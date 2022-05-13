class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.1.tar.gz"
  sha256 "33fd10a8ec687a4d0d5b42473f10459bb92b3ae7def2b745dc10b192760869f3"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fe99b75d9e37e3acd653f93d429af93f94c5460a50284e6c56cf99fb4f8aa7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40417555a252c5ea054b8e71aeb99af82fafca14d3f93a7f6c1555bab64352a8"
    sha256 cellar: :any_skip_relocation, monterey:       "67dedaec2350dcd6535d442cfe152589c743141cf72a078fde582f0e15be1b48"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfbdb089a9742a91c4568ab84d90cb285f43c635e999d67aa8e40abc570eba55"
    sha256 cellar: :any_skip_relocation, catalina:       "696eaafc168fa04a4f36203e2e76186cd534fd007feaa7d813fb21142680380e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6217894919a4025d748e4cfd64cb94a809cc8db7af731e16520924b16623c49e"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # Tentative workaround for bug with gfortran 12 and clang
  # https://gitlab.kitware.com/cmake/cmake/-/issues/23500
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/533fd564/cmake/gcc-12.diff"
    sha256 "f9c7e39c10cf4c88e092da65f2859652529103e364828188e0ae4fef10a18936"
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
