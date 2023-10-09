class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.7.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.7.tar.gz"
  sha256 "08f71a106036bf051f692760ef9558c0577c42ac39e96ba097e7662bd4158d8e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d0e8273d7d68bc7ea90ae17eb93224310651d7647ec671399543010e74a3d88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e829c02f42d2e537e53afd0dddc71b8c6c273e1833e8397832f361f8d174851a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a348a8941dd86d6a7874e17179b899e8a6027c110bc0ba948fcf8dd5bb9c012"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea936713b48a9aa9d9ebe475813ee7584330036daf0d46cab65ebb0b499b8561"
    sha256 cellar: :any_skip_relocation, ventura:        "2def2d0da9593cb6cb0e1e766dc24f79ae32d0ace674cc1557dd26ddad6bea40"
    sha256 cellar: :any_skip_relocation, monterey:       "169d7470c7f42fbd8c3cca48b2fc0eeea74002d01b9180e632f60f131b4ce7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee1af113dc60deb4a7ecf65acdc78df51b1a4b2d505d1e56862b44a6867ddfc1"
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
