class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.1.tar.gz"
  sha256 "4931e277a4db1a805f13baa7013a7757a0cbfe5b7932882925c7061d9d1fa82b"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a34be33eaf8357384632cb8afc43b0c9f3fc48e38ee4e3b2d5d132a6a00a50e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c79934995481d67839ed776878bdb211de434ad80e8b8585e367666d83e644"
    sha256 cellar: :any_skip_relocation, monterey:       "06e66760341461b3dba96243f01930344b32dec6d168a7f4bccc2e0dd15a78e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cdd4b992d969cb49149513fdc9fa1b6a857e90c864e841bd1b3b319074bbbb02"
    sha256 cellar: :any_skip_relocation, catalina:       "2b84673d4773f8cdadf1b1cbac7892ff9e8d9c1328365e7c897b4cb1d296772e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37a1eecc3306d44f7ba1f8e70337056b0ef446f9124094ef7bec7e29951eadf6"
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
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
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
