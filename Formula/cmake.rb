class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.25.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.25.0.tar.gz"
  sha256 "306463f541555da0942e6f5a0736560f70c487178b9d94a5ae7f34d0538cdd48"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80c206a6884a52914d09c72ff2e64079ae0d99aa7fde58dea73de0faba8f6d6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ed5aef087d93f4df171e82f72df5c6815ce7151dbd4b370e70d38e089603c37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f440fd5a4495878ffab7e1008a6c874d4606f68d514f154520a55e4194c8a680"
    sha256 cellar: :any_skip_relocation, ventura:        "2466f08623841c1acc932331e5b44fdf9a987e5c074d8605fac96ebf328ad080"
    sha256 cellar: :any_skip_relocation, monterey:       "c472ef54bbaf367467ba85887895f987835bb2843a1c74a76eb05edc7b1c12b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "532b702a317ab864e46ca7b6c3049183fbdad97e4fde66ef341bfae147870d49"
    sha256 cellar: :any_skip_relocation, catalina:       "3ce6b4c1f589cb3dbd649deaca28de53ad8f87c677aff56aacdded5d4d720f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ac2590421355917f7f5fe948fca4f135fcf33c735a51c12be66436bc069423b"
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
