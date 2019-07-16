class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.14.6/cmake-3.14.6.tar.gz"
  sha256 "4e8ea11cabe459308671b476469eace1622e770317a15951d7b55a82ccaaccb9"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c421f98d773951dc9cdb0888e01262e65243c1c19c05e6126293c30e835f912" => :mojave
    sha256 "301e78f6aad3a0072abb17ca0661618d8091235cee3de5b2bca730f5c5030769" => :high_sierra
    sha256 "5e052f843afebb90e17d44ae00257dc8781661f5af7d9c6f6dacdb789c14b790" => :sierra
  end

  depends_on "sphinx-doc" => :build

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
