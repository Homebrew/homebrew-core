class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.4.tar.gz"
  sha256 "313b6880c291bd4fe31c0aa51d6e62659282a521e695f30d5cc0d25abbd5c208"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68ab4f8a848bc38b041e837195de76e66b872da9d9e7fc40e23460aac7dae1bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca5d856950a397dd30286f291975628626559db8fe3a7eca7b0cd8b07a44f6e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53f1290aa44b51fb4fb891a3e11b34b4f3761821d5f1d66314eb90770b46f439"
    sha256 cellar: :any_skip_relocation, ventura:        "7a48fae8706abac0d5c30e88c83bd8eed6fe44e0239ab30d1f20fd74433e5b30"
    sha256 cellar: :any_skip_relocation, monterey:       "fed2e89cee2d4945288345eb98c9f04631446047f5b923f3a3d70f5289e4c73d"
    sha256 cellar: :any_skip_relocation, big_sur:        "122d37e4f077d428327d055c2d749879dfb76077feeaef268787e7790a25c3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfdacde4ae0a01d5d07e70febc6b25cbbbf176042da8d34c669210cd457418d8"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
