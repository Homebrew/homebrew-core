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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a79bb58cd630e6fc9e046401cf29cbcddd6f4f04d4cb7ef400179bab3835586d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4982b3c7cee82a6184c4fbf1cf26070c23e47c313c842102667f836cad4a292"
    sha256 cellar: :any_skip_relocation, monterey:       "5e3d045a56871304e5877eed32de5f18c4545a31b147085b5edfa467293a352c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1cd665353ab92e8de784408cb35ef1a97b88a6911ac4b1cfa2aee1fc97fb47d2"
    sha256 cellar: :any_skip_relocation, catalina:       "e69c2bad2d38229f0fe8650a5ea116c250557582650b7d16f9bfa6f910d9e4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f086685080d604eb98fbeff70d831d382898a7bb67e44e1d95752e1dca49bac8"
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
