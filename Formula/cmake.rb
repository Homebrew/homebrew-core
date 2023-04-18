class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.26.3/cmake-3.26.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.26.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.26.3.tar.gz"
  sha256 "bbd8d39217509d163cb544a40d6428ac666ddc83e22905d3e52c925781f0f659"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a01063acf507e4764f177877e75fd17344273df01b3709d8005add14aefb2ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbade10fa06396b4fec19381a9a2a01fcb4b39dc6c8551ea7fe4502a135b5458"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4a8aea5dd387f6a1c9864852975e836db951deaf6807ab84e2e4c063dc38426"
    sha256 cellar: :any_skip_relocation, ventura:        "18311d1301859a355497a7f02d45d1988083ae1ee7a8c7a74480fc1e1c4ce2d9"
    sha256 cellar: :any_skip_relocation, monterey:       "7cec5ba13f927bacf8dce638766bd8465c7e27b22053e78038658aed3feac917"
    sha256 cellar: :any_skip_relocation, big_sur:        "806ca6e8fea679ab036fdaa6b116172298a85e202ae502c25cac3e6a2519450b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "942c1b66aa290551f449161466ad057f403b627ca8db27d3f6988e3c7594ce87"
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
