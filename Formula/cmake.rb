class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.0/cmake-3.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.0.tar.gz"
  sha256 "4256613188857e95700621f7cdaaeb954f3546a9249e942bc2f9b3c26e381365"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6bca8ed62e290a758ebca2a3c0d4a8718ade6314bc74a59469b3b45d1d4a491"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2496d163c3abaafe520103ff936e52f7c2d5180aab810f321495d054a84e741"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7343c1a1d7164890c8b3bc9f708acc6ccce5a2d615d1a071ffb43e3b85a5d15a"
    sha256 cellar: :any_skip_relocation, ventura:        "0169530a58288da95bcab554b77e7fde68959e4c319896d33104c299d723c821"
    sha256 cellar: :any_skip_relocation, monterey:       "e420b77007b2641cd9202f7d3c6a46001e668c761ff2415a497a55a34cbaef23"
    sha256 cellar: :any_skip_relocation, big_sur:        "02108cce532e25f882ff322eb7ad08b0ef703699fd0bb227b4b33c6d1612e4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de69da1eb7d50aa82a0db15b3ce59a55e38a06725b4f5f43f0f0e2b15177783"
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
