class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.27.3/cmake-3.27.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.27.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.27.3.tar.gz"
  sha256 "66afdc0f181461b70b6fedcde9ecc4226c5cd184e7203617c83b7d8e47f49521"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "507f07f1cde3a64ce2deb17e21ff1d4d3c078ec13b3a5735772440ea2a8be066"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29f4b6cc9de7532fd2212ecc9e396d8dc257a2e1f8efead29537c3477be6c69d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "014407f2e45ff8ee21a6806d4f007d3933fb2425280a65f7532e91dea8d6106b"
    sha256 cellar: :any_skip_relocation, ventura:        "f7491440699525445ed6a140f55a6f25bfa1f811292f4b0eb93d7ce99a2c7fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "6335e66a62aa647a532c5a59e438cd78b23db1862073981de94171530df3a1c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "04d0a4d9d0651de3322e0b6cccb12f37c3d9c17d9b5ce998cfbb6637a5478caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af32bf16d57afa1f0be35ac93917d8a7d7ab6242ea88e37985bfdf03501196e0"
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
