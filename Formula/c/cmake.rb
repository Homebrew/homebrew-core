class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.2/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.2.tar.gz"
  sha256 "36db4b6926aab741ba6e4b2ea2d99c9193222132308b4dc824d4123cb730352e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af3a67e244d5d201d0fcca342ac274bd518bf5101056a4a18897e46770bc7979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "149abab22ca4f0473717fa6e019c816b26377be1974c55ab96b9b7db68789105"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c4a6eca08be0bebaa8a54c272ed8ec406d7e27adf7371e899a8032c860d3edc"
    sha256 cellar: :any_skip_relocation, sonoma:         "4489c01846145cadb0547f8c75b7dfdbe83ea8a6d528c07df2a1650c9a1b8897"
    sha256 cellar: :any_skip_relocation, ventura:        "f3e0af8039fbea6af3c029a60c04f24ddb67d56fc9cd38ed6c4b84eabc4db197"
    sha256 cellar: :any_skip_relocation, monterey:       "634661b000aa8e9a788742e09eb63b6a61bc9a973c1cd2704e8497c616377a54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93280d3833fd1817459ae3f746ce7650bb0874ea21dcf412a82b40380d15917"
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
