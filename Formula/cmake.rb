class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.12/cmake-3.12.4.tar.gz"
  sha256 "5255584bfd043eb717562cff8942d472f1c0e4679c4941d84baadaa9b28e3194"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bcd5ae043d2a6fd5983b026ccdc70b7594e0dbe9de4d367cfcead7edf3c8596" => :mojave
    sha256 "11eab1d25ca73bbc2099058af7a434af465e61d028c4114627069fdb999df9ba" => :high_sierra
    sha256 "ef818ca63a0a2836aa881c9333bec61738261d0dc0e975cd82e4cacb1fc8fa3d" => :sierra
  end

  depends_on "sphinx-doc" => :build

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew cask install cmake`.

  needs :cxx11

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    # Avoid the following compiler error:
    # SecKeychain.h:102:46: error: shift expression '(1853123693 << 8)' overflows
    ENV.append_to_cflags "-fpermissive" if MacOS.version <= :lion

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build
      --sphinx-man
      --system-zlib
      --system-bzip2
      --system-curl
    ]

    # There is an existing issue around macOS & Python locale setting
    # See https://bugs.python.org/issue18378#msg215215 for explanation
    ENV["LC_ALL"] = "en_US.UTF-8"

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
    system "make"
    system "make", "install"

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
