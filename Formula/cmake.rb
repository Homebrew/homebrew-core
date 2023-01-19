class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.2/cmake-3.25.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.2.tar.gz"
  sha256 "c026f22cb931dd532f648f087d587f07a1843c6e66a3dfca4fb0ea21944ed33c"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f8c449c90fcadd16eb563457fd86b1ddc6198115d14508b8c8390621949758"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc7d44f45ab5ad6eac933469376e190ba84d155b6cefe0a81de8be18bca3b64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d576796c7c628dfd3e3b366c72a7a644f8845fc6a3b79fda773dcadd7db15f48"
    sha256 cellar: :any_skip_relocation, ventura:        "226398832271d389f3e0e8df50ef2c6d94bddb3a982878fd69bdc42101d41790"
    sha256 cellar: :any_skip_relocation, monterey:       "0f9dd2bac1f973de965f81b5a320d8da326bd2cc7c2fa2fccf4ae009f98490f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cd2f4246c20790eb0f1e763766362dcfb2ffdac5bac99dbeb44613439a4e8fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20805e85cbc6dc7e4e5b3a4727345e6cfb4bd265e6f56b39b299b313c74db6ed"
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
