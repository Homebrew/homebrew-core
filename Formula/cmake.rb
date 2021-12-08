class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.1.tar.gz"
  sha256 "0e998229549d7b3f368703d20e248e7ee1f853910d42704aa87918c213ea82c0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ecfdea833356807af17016cd40db4d51f04ad6c00479e2c24e0b9ffbe5669e8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d9ea0ff84b173d77d43bca4ee8a0e872e488d3f2ce06e07ab20bee466a40860"
    sha256 cellar: :any_skip_relocation, monterey:       "7f30bf504b33a348c4f32f5c25cefe652338ff311bd99022c6a9efd2ddbe4d48"
    sha256 cellar: :any_skip_relocation, big_sur:        "314a6bcd592a14572b5663d7755ce9bfc5a4932a2984381590e18bcc952d1101"
    sha256 cellar: :any_skip_relocation, catalina:       "09e9306dfdef62f8ee4e422c11a37c0bd629e1089006c490fa73ffbb75232f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05aa882d599b4acdcb544ddd14c73869fde2d566739462fc208ce9e2ebc8b5c7"
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
