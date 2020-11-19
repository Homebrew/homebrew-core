class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.19.0/cmake-3.19.0.tar.gz"
  sha256 "fdda688155aa7e72b7c63ef6f559fca4b6c07382ea6dca0beb5f45aececaf493"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  livecheck do
    url "https://cmake.org/download/"
    regex(/Latest Release \(v?(\d+(?:\.\d+)+)\)/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e812869b03bb867cafd5b71fa36afb795b44a59a907f132f1b6837ea72860a0c" => :big_sur
    sha256 "c7c42e66c63448e4aee44498b374c9985f477b129fccca5dd9c13530d1e680ef" => :catalina
    sha256 "a0b167ad7f2fbf6f6dbcca9d74cb09acbd7822c54873803e940abf04272f8028" => :mojave
    sha256 "98704ab50ed76df9214083c01e373277ba02aad43c858182be7ed1466d005326" => :high_sierra
  end

  depends_on "sphinx-doc" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

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
      --system-zlib
      --system-bzip2
      --system-curl
    ]

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
