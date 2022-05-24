class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.1.tar.gz"
  sha256 "33fd10a8ec687a4d0d5b42473f10459bb92b3ae7def2b745dc10b192760869f3"
  license "BSD-3-Clause"
  revision 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf86014bad1530281eae10aa354ba3ed8ef392c5ea71f3a344dd36cb237f3e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a4005ba2f7ea9ec553e26b7680476095b4511b45371275ef6955d83d8a2f3c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a6a698747b627db43349e0bccf4cbd63c65a18bfabb552dce7ecbde4d3d32962"
    sha256 cellar: :any_skip_relocation, big_sur:        "cca79b0985dd2005a065bf193ed550133b4d749333d50be98a496f95d0dd2a25"
    sha256 cellar: :any_skip_relocation, catalina:       "ec14613229ae3836f61f03ed553043471fffb5a6763703f7ec87fdbdb339c5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75f0a3c62f4d481dc4e908ebf38ae02f50aedbd81fdf66ff7332d4698886d23"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # Tentative workaround for bug with gfortran 12 and clang
  # https://gitlab.kitware.com/cmake/cmake/-/issues/23500
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/533fd564/cmake/gcc-12.diff"
    sha256 "f9c7e39c10cf4c88e092da65f2859652529103e364828188e0ae4fef10a18936"
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
