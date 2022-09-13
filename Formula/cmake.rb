class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.24.2/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.24.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.24.2.tar.gz"
  sha256 "0d9020f06f3ddf17fb537dc228e1a56c927ee506b486f55fe2dc19f69bf0c8db"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9127632ab72ddb79e659fb87f194bc604342948bd332499326860e02a7cfa4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "324b9abb0023ce29c80119d2b0d1361ae69bc573e2dcdbcd2f5bfcffe715a6e3"
    sha256 cellar: :any_skip_relocation, monterey:       "d40d888e7ce0d4fa898bac4c8afb964c9a4fa3d7d9a4877fc7223a2ee3160e96"
    sha256 cellar: :any_skip_relocation, big_sur:        "e95e1f4a6c430affa61a458ee2ea3fdce1a76a6f4a5c358382187f28ec20535f"
    sha256 cellar: :any_skip_relocation, catalina:       "ae58875a2d89c985e92348cbc2f848433b31f2dad2a94973bce7f135c777e0c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e58aeb64631bf97d05c12d8efe72b45d6ec9662e891b7abfa0e25b2c7af1ac7f"
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
