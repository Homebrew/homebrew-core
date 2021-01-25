class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.3/cmake-3.19.3.tar.gz"
  sha256 "3faca7c131494a1e34d66e9f8972ff5369e48d419ea8ceaa3dc15b4c11367732"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f1120f447d6e6ff9710093470b1106070d782bb68fcd9b79bc624c9171da636a" => :big_sur
    sha256 "b5fef3755c9e9f38b2bf9d70498e5af7c6e71d161d6c122909ffdce7373340c6" => :arm64_big_sur
    sha256 "0dd30e9dd06a0ebb6bf08288f119f19a7b5eca01a954cd9333103bb74b32a556" => :catalina
    sha256 "b737584c31baab662cdf3a9509b31399cdec6b1c8bdfa795f50b2dc75c83c0a2" => :mojave
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
