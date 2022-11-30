class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.1/cmake-3.25.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.1.tar.gz"
  sha256 "1c511d09516af493694ed9baf13c55947a36389674d657a2d5e0ccedc6b291d8"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e98c55285071fff328c78d987684598b7ee0241950573d2d2c833b2da1290c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25bbe90c5ce335b948e098d4b0de7b680793fbe12e93162e034b7e35554e6fb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cd53b5c39d1def448201935cfcdf0a0018840734fab0fb68753762089ded548"
    sha256 cellar: :any_skip_relocation, ventura:        "45eb7b789570c7d8e2395e96227fcb859f3e154d65e253bd238cc1facbf2f113"
    sha256 cellar: :any_skip_relocation, monterey:       "986e3351822e814c8ec025fe5c8d319da6afec1e6daca74985d4f741766ec236"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4a749ef3d901929aca20767730befe22cea7801d74137e2179aecbd11904720"
    sha256 cellar: :any_skip_relocation, catalina:       "0edff41ac2870ef54bc7c4710b60323324e96194f6fe9aa8a8cd4047f8310fab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa5ada1d3a59de6702a61fbcd8896fcf5b9d6419e6874d804c14d285916a6f35"
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
