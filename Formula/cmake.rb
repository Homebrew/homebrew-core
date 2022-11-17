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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97a9ab6431ef7316acd1c817321e64f1e4578016e4f3fa691b43a897f41e90bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb05904709bc38c7f279af5ebc194e3b819642d1e5bf46001d739d87172b1e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad48ee6c0cefc090ffd2a0225f95bd6abb53dee900bab819699162cb49ac756d"
    sha256 cellar: :any_skip_relocation, ventura:        "ed128f70fc88e7e8855c3fe44a2e23ff453b02065f253e0ee5351da79bdfb0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "ab22f15a6500d726a3cbf4ece6e09cd9179684961bc60e9c4777ec1e08ced207"
    sha256 cellar: :any_skip_relocation, big_sur:        "23721d4f22c83935837e9e627dbff5770b511f1b4873f91856a61bcfbe567478"
    sha256 cellar: :any_skip_relocation, catalina:       "3dcb69e729ffb8eece37e9857fa295de8e05b4e47f6aa4f920dfdaf766eb1a18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e82e4c41eb63f91f6f2e1d8a95f608c50ee7569a56f46388ca18c8bad2370d30"
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
