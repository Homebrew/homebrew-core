class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.5/cmake-3.5.2.tar.gz"
  sha256 "92d8410d3d981bb881dfff2aed466da55a58d34c7390d50449aa59b32bb5e62a"

  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "addda85812b6af991011cb6c5e640a2fe25e6b60415931e1c5a76ce2675c2988" => :el_capitan
    sha256 "4888f6163be1b5e4affaa5ebe4b118d64b1b81bbc92cea884803bf098d9e9cc0" => :yosemite
    sha256 "b1f3d72e7ee352da96a577638b3abda8aa9f894b5ecf91350667f89821bf7304" => :mavericks
  end

  devel do
    url "https://cmake.org/files/v3.6/cmake-3.6.0-rc1.tar.gz"
    sha256 "2b83faac94c6421b02546ea2728f05568bfdb7ba7961102ecfb6c583fe889027"
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-zlib
      --system-bzip2
    ]

    # https://github.com/Homebrew/homebrew/issues/45989
    if MacOS.version <= :lion
      args << "--no-system-curl"
    else
      args << "--system-curl"
    end

    if build.with? "docs"
      # There is an existing issue around OS X & Python locale setting
      # See https://bugs.python.org/issue18378#msg215215 for explanation
      ENV["LC_ALL"] = "en_US.UTF-8"
      args << "--sphinx-man" << "--sphinx-build=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
    end

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    if build.with? "completion"
      cd "Auxiliary/bash-completion/" do
        bash_completion.install "ctest", "cmake", "cpack"
      end
    end

    (share/"emacs/site-lisp/cmake").install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
