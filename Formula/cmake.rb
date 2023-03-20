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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c39c077ead3f8ccc94727c275ac16af5f75a088844df034d10b34ad85dfb8bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fb143b21a378921ee86e61d0cf77584e42ead38076f92ea1ebb57dcefb6b85d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "714058b6941002393dcadcefb13f5b16ae094724c734977cc6a2dcf2db5484ae"
    sha256 cellar: :any_skip_relocation, ventura:        "96a930fa2836355c767057f336521113f419f51c2444ec0cb095a6776170997e"
    sha256 cellar: :any_skip_relocation, monterey:       "ca050ee8541df0df30c3b06bcce0b8be0a37fc16dcfc83fe2c29dd6bf13b8643"
    sha256 cellar: :any_skip_relocation, big_sur:        "5175a6fee503ce7cd67fd6d23ea589995ac1d0eb8114756315a106b8261affda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a71c04366f7b5fd26d49bd683ae3a2cab717967085fd60ffa8bc8c802a9f9c48"
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
