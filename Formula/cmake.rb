class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz"
  sha256 "189ae32a6ac398bb2f523ae77f70d463a6549926cde1544cd9cc7c6609f8b346"

  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d44d2cbbb2a874811bc66fd28b946666aebf14a5c57b98b9c9284ce2590af5e5" => :sierra
    sha256 "4fb26aa213968e98ec918227033288f51244c93ec31505c74481d165c9a26173" => :el_capitan
    sha256 "17cdcd37313ca26d6e6fca29ed96b489c63523d74d3077ace4d5cb671b9730de" => :yosemite
    sha256 "ce89b3f58c40a2154dc7c836340758b6d5dc3aadf0215961a2fb0200e370f3fc" => :mavericks
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on "sphinx-doc" => :build if build.with? "docs"

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
      --system-zlib
      --system-bzip2
    ]

    # https://github.com/Homebrew/legacy-homebrew/issues/45989
    if MacOS.version <= :lion
      args << "--no-system-curl"
    else
      args << "--system-curl"
    end

    if build.with? "docs"
      # There is an existing issue around macOS & Python locale setting
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

    elisp.install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end
