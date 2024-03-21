class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.0/cmake-3.29.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.0.tar.gz"
  sha256 "a0669630aae7baa4a8228048bf30b622f9e9fd8ee8cedb941754e9e38686c778"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0906dcd328656151c298ef7a3bfb6e5846803a2a9c9a2f718ee89af87562b35e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a3958d664556b8bb8baf40030d3ad2e4414033cd229175bad1d0f4c8696cc61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d72621adfc29cfef9641383a842009c32ff9cbaf49638e1330b3c920b32c2640"
    sha256 cellar: :any_skip_relocation, sonoma:         "8523c0b3fe2901a27e7cea4308b18fc43d365315190eb62093fa5a268d805818"
    sha256 cellar: :any_skip_relocation, ventura:        "5570998e1c56c777f172ab6d5dcf6afab0bc36735e97408648248fc3d214d528"
    sha256 cellar: :any_skip_relocation, monterey:       "1a9c4da7bb59ee27e68752f73b288c02fd7bd608ec28fd8a3a28fda75d33b96b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f487ba1e6d7c19542073bbb653c932e792c8de23fc37225de466420f9ff81fc"
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
