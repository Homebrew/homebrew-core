class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.30.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.30.5.tar.gz"
  sha256 "9f55e1a40508f2f29b7e065fa08c29f82c402fa0402da839fffe64a25755a86d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "127ba44c5c05ea76e07bd3e12f4790d3bc48569e6070db4119d28ea92332fd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9ed9f9fdeaebad52864e22e76a185e71b9856d538cc22880e2bff11475ad1ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "423675ebcf07b3493ae59213b23c1eb94e18c16cb4e166d0f393018145a524d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cc981e733bca105cad4498fd6186298ccd09cf9043ed24fd27ec312d0eecdc0"
    sha256 cellar: :any_skip_relocation, ventura:       "0d31e94aa2210dc61dffe9e1ed90013d50984ba2289b48b449a39b66b4b51f4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9070b4e3a8164ba46d20fcaead7956cbfdd8eb9bdcba7f9952e433ab18e95738"
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
