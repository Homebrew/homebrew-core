class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.30.0/cmake-3.30.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.30.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.30.0.tar.gz"
  sha256 "157e5be6055c154c34f580795fe5832f260246506d32954a971300ed7899f579"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b864bcbb0c0aac959cde14af300fb104bb3c434777457ad9d5923e717cf4fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07446e2140e0a90433d81a68b8c123b40fd4d34c08d50ef120d092dbadfacf11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6169f3054832324b28bc78432d38f00f49636d376d6e90fdb30a2fc65c49dcef"
    sha256 cellar: :any_skip_relocation, sonoma:         "8693bc59564fa57ed843e1187bf3772c0c6231e83fdb7c7814a5704a46add501"
    sha256 cellar: :any_skip_relocation, ventura:        "11ef88297600b017aeae08ba0418a7c931f6587ad78ca781e340b17af3678837"
    sha256 cellar: :any_skip_relocation, monterey:       "092f2e7ac837ab65670fd4c87085726ec90e50c680044cc198b4eda2cc3825d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd9fde3a487392c905cfd68bbc72893521fd8f1ca353ddf38eaa241db6bb8106"
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
