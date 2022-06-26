class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.2.tar.gz"
  sha256 "f316b40053466f9a416adf981efda41b160ca859e97f6a484b447ea299ff26aa"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46711ae9d567064916561c472b94cba0e939ae72479f6f51ebe98dc6995c4422"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "023ee5973e188773685ac3103a87302a0a107de46b9140f9bcfc79f9e36ebbe4"
    sha256 cellar: :any_skip_relocation, monterey:       "7460c9de7872e142b6f813383c2247ae9bddde7525fdfad89967098c65bb71ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "93665558080df1dce04ad328e3ccb3166fa9077d5ce20a5723760fb8558d3092"
    sha256 cellar: :any_skip_relocation, catalina:       "183a79de83330f0c518f94494579dc94feeeea7615bc0735759377fca5713f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d424e4ab59606d02805aa5fa4c05ef3a9558cce67415d602f1e6781e2aa70ee"
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
