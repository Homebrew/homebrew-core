class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.4/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.4.tar.gz"
  sha256 "eb9c787e078848dc493f4f83f8a4bbec857cd1f38ab6425ce8d2776a9f6aa6fb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91fc13f7284a925a794549c0f708b612a4fa87b0fdfdf6d224fd14512aaa1397"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "971a7a7ede64c866acd74211c51b14ccc9f15d5214538b7f2c386cfcc9d5df17"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53c78bcbe47be5bc2f2512f679a760e5b9d596724773ddb31f58e3abf8375f9c"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1e4a8a2bcbb4dd3f447fa59761ccff46553d452100bbcc69aa730b74daa6481"
    sha256 cellar: :any_skip_relocation, ventura:        "eb0c7a47da85e62faa20aa5f89da9180d026eb400266249f14219b972754e0fa"
    sha256 cellar: :any_skip_relocation, monterey:       "d3219efe5909c5ee3cd3827b719bf7f1dbc22a5ca0ab4ed65d5f72b204a6e334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3004aab27511db3212d6fa3bc60958ca8e6c6d2d2739c538bba5f39f9f8aee7b"
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
