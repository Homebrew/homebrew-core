class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.3/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.3.tar.gz"
  sha256 "9f8469166f94553b6978a16ee29227ec49a2eb5ceb608275dec40d8ae0d1b5a0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf3679a38dad3ea9c304e10059696c64730379ddc80e859e5f0e4a75986a2677"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c324895ba3796e7f5b24fcba6091fd7e204471a7ddc5874ca2737550702846a"
    sha256 cellar: :any_skip_relocation, monterey:       "45b1e48b94fd1a676e925e8aa0db5de8f86b269f7a5844ea6b072116eea88092"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac8576351fc40602055120bff8f9d99b35c76378c0253cf9c1d24e91fd6e9872"
    sha256 cellar: :any_skip_relocation, catalina:       "601eade8d348a62618e88efe8428166ef5c12f41e90f3b8bbd6f35344c05a8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c481ecf323f530e5adb66cc68ce5895694a50e91829ff87793e4494483156ad5"
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
