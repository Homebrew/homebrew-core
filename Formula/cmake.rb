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
    sha256 "474ab1548e4909a2565f44c46f90d03061211f695403419aedc2d7a2b71f1db0" => :big_sur
    sha256 "ae145ddaf2b17c3a02cf76f06cb217fae88a0a009e409de00fa1b347a00b0c16" => :arm64_big_sur
    sha256 "4119d81cfa8435976e667af76a8b79a35f34d97aab69b646b2356eb69b8edf78" => :catalina
    sha256 "2b2cee31bfce62a116567bc295eca855b008630aafee860051aaa599eac7d657" => :mojave
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
