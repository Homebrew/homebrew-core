class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.6/cmake-3.27.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.6.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.6.tar.gz"
  sha256 "ef3056df528569e0e8956f6cf38806879347ac6de6a4ff7e4105dc4578732cfb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c11b46b80802b4c771200ed0cc1f4b1b3fe61d3c8973f28be1588286dfb5575"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af2d6a2516422a62f4fa9cb50edee566e28b620230faecab3ea549b6443015d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "497777c0a31e0e0b4295ae1c8307f87d2ec6ddb6293ae7dc525509f74f5e81b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "05f8b2623ef60cc15befb24a513e07bd7bedeec488793b4c26e3964ee10fa5ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "78f51a7e36344ac404b9cd37376bae06e59c172e5d9e1d2b979ca3263b4639bb"
    sha256 cellar: :any_skip_relocation, ventura:        "d3c6d68df9096b7e05b803b7cc34f968c083b875efed010489eeb1bdb769c0a4"
    sha256 cellar: :any_skip_relocation, monterey:       "35b1f95518597d2aea891b746d259ec714826978076cd8046e30500030a77dcc"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e4184ab197af1418f3a2463f4147835e09f9021d2ffd2d0dc071a4ab350d3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa8636f4d9bb073c1457cba6041a5750ba9ae0b017eea4879b10daa61763c02"
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
