class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.0.tar.gz"
  sha256 "c2b61f7cdecb1576cad25f918a8f42b8685d88a832fd4b62b9e0fa32e915a658"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6fa403bb9e78f1d0d07aabc66662a23b05d0d2279cbf63c6d79970634f8b62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c832454186e2fdaed6c01dd8ca6c0e78c390fedebb41f866140ba0f3ee7e65d8"
    sha256 cellar: :any_skip_relocation, monterey:       "74c5b0913d367b68ce7d7c7eea88d1977c1c69c9d2d0fbeb8c3c171b29db4c61"
    sha256 cellar: :any_skip_relocation, big_sur:        "d239615d84f9268363ae4fd510382ccaedc8f667e1dabd2373bd7c09af0316f9"
    sha256 cellar: :any_skip_relocation, catalina:       "60b3476753af0e16cfa6664142bddafa00ec831b7a9fd8f85e215a60d2c1b11f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d00b7ed4bbe2ab07d22ab2e6d34e1e04968b908051e1db08012b6bd6a5e4c6"
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
