class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.20.1/cmake-3.20.1.tar.gz"
  sha256 "3f1808b9b00281df06c91dd7a021d7f52f724101000da7985a401678dfe035b0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e5a0decfa2ca5124a5d121c910158769d91349e3f71ce5b13440c03f93686ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "2009fffc8a892b78728e45543f284e27d236c0d79ee55e00ede63f9033cd9a00"
    sha256 cellar: :any_skip_relocation, catalina:      "7f88151e25d2ba441c8a53fc7ab443547c582670bc53e894e1ce208b3a3f8499"
    sha256 cellar: :any_skip_relocation, mojave:        "1664ce1a8719c4a3432cbe6d1c83402a58699a823a403fc3d09db85a8db19741"
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
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
