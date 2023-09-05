class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.4/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.4.tar.gz"
  sha256 "0a905ca8635ca81aa152e123bdde7e54cbe764fdd9a70d62af44cad8b92967af"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c4d34968dceba054a8ad70abb80cbdae583dc651e9b1557974669252f0aad8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f646ef45e3c87361537b7304f4892908d0e60e26b2f547bdec006f15dd71c17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a7b83475cb193bed54425578c489c0c7f06019ac447e364a5ce482b5cad4dec"
    sha256 cellar: :any_skip_relocation, ventura:        "66c91d5483a402705f6e3056fe8f20f4d306a2dbc416e610be95c0c6c01af987"
    sha256 cellar: :any_skip_relocation, monterey:       "df2b7cd7ab6f8555c472e2e0bbe9c0b180ae8eddaf55738bd926b5deb01bc4bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "5984934bcfb28161c87c12f13ced8f393ad1558cf30ae443f0e50b1c9b269fef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "800a823a8d8bc50325088a294d94f40bdb29b92c7dd5d4b13c63b07f5830183d"
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
