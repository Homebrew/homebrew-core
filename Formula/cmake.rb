class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.0/cmake-3.23.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.0.tar.gz"
  sha256 "5ab0a12f702f44013be7e19534cd9094d65cc9fe7b2cd0f8c9e5318e0fe4ac82"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d813ead3b946f133c3c7f2c1f65d84f8656477bb427bed26a65a0992a59ad1fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b965024ffe4e17c1734194a5ff18dcd25a5ceba332f94ce10a580600d0249d1"
    sha256 cellar: :any_skip_relocation, monterey:       "90603a0e61d228dd80892cd940a17ac6ff12a9435091b2d54bbc0e7007d7065f"
    sha256 cellar: :any_skip_relocation, big_sur:        "65d5b564ea6909d7badad28730b1d260f85a5d685f294a48b8c77a56914085be"
    sha256 cellar: :any_skip_relocation, catalina:       "a3659db581f7e584de18de86e50470f7ab7f4c83eeeb8200abdca927c8bc5fbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b72bdb4ad0c7d7dfcd757e41533c4043da85f7132efd4f77086addce57f07862"
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
