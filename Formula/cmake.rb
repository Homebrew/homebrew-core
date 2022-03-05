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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94988c6bbc00c7a19a32d0b926dfb4c945c3ab975dfd0c4116811d25c92cda51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4b10cbe4e3244b0746b9df005225244ed8572d954b302a51d363b3312ae76ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "090acb6a5c51b9a3b74508e7a93e30d6bcd84c55d66ba875a68fea31c696ddb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dc87fd03f45aebc3cc70226df814cd87ce3a362af334f48c1f7f0ee5ef0f222"
    sha256 cellar: :any_skip_relocation, catalina:       "4c02a897c373424db03e17c1f3e15c88aa0581e6a7b0072eb6e650a70222f9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba4b68c1eefa82fc4661ebec979b7289fe453f2504c5756ccd417d9aa3b4adb"
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
