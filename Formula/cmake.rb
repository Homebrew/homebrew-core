class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz"
  sha256 "d14d06df4265134ee42c4d50f5a60cb8b471b7b6a47da8e5d914d49dd783794f"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c0a200641e3737b09d61f20850d2dfe6379533cbdefcd6c512bd8e7c1d20872"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbece5192774308bf40ee7df06fdd4bba9ee6671e4e2e740072ec04cb9bef0c2"
    sha256 cellar: :any_skip_relocation, catalina:      "a039c944e143dd97b05b87759d78cc491bc294336798ff4e141feec878303200"
    sha256 cellar: :any_skip_relocation, mojave:        "878c2ea16ed5b0adefb421f62f22036179c340854a33d2b6a340c0c3f35e7932"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dea47f34b872ebab95f095f1347e28ece1931c5d27f1295ad09e3295e5e014"
  end

  depends_on "sphinx-doc" => :build

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
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-html
      --sphinx-man
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

    # Remove deprecated and unusable binary
    # https://gitlab.kitware.com/cmake/cmake/-/issues/20235
    (pkgshare/"Modules/Internal/CPack/CPack.OSXScriptLauncher.in").unlink
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
