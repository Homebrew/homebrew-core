class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.8/cmake-3.8.1.tar.gz"
  sha256 "ce5d9161396e06501b00e52933783150a87c33080d4bdcef461b5b7fd24ac228"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f315f8f2bf0d6727c7724ab4d55d91a28ec0043ac3fc799989a88ff8ff104a7" => :sierra
    sha256 "faa87738bfdc8af63e8bc98e41f5c81b25015ea94b02c94865132511203eadeb" => :el_capitan
    sha256 "88af0fd8c30ed07b23ab64a59ad59478c686d459765de85f4de14b4a210a64f8" => :yosemite
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
      --system-curl
    ]

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
