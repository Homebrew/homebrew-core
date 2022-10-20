class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.2.tar.gz"
  sha256 "0d9020f06f3ddf17fb537dc228e1a56c927ee506b486f55fe2dc19f69bf0c8db"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "059834cf5a851dd7bbb7af20bcd6c3f5bf6530d1d7a143b74995a1e5235a857d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e3de5c55f543596e7e883dbf175497c2b5affff37bdf5fbf37922b50a84f75d"
    sha256 cellar: :any_skip_relocation, monterey:       "fc9cb2aa232dacabf2c689d1c414971e76773c84a91fe65548338447a66c3860"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bf28f6c3cc967b8989e352404e7132a3393dcea1ee82d84b920c868fcbdbc7c"
    sha256 cellar: :any_skip_relocation, catalina:       "de92be9bafb7d4c8959c275792aa46b923c329869a2915653cc1564c55ba05ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94d71c01399d11fd622f1bf3dd659c6c59c61cc033f687dc6a206e5ef3b02509"
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
