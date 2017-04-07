class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  revision 1
  head "https://cmake.org/cmake.git"

  stable do
    url "https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz"
    sha256 "dc1246c4e6d168ea4d6e042cfba577c1acd65feea27e56f5ff37df920c30cae0"

    # Fixes upstream issue from 1 Apr 2017 "CMAKE_CXX_IMPLICIT_LINK_LIBRARIES
    # broken by latest clang on macOS"
    # See https://gitlab.kitware.com/cmake/cmake/issues/16766
    # Upstream commit from 3 Apr 2017 "CMakeParseImplicitLinkInfo: Ignore ld
    # -lto_library flag"
    # See https://gitlab.kitware.com/cmake/cmake/commit/53f17333f830d4f314bbe10ba32889bbcfbc3c46
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/12bc44d/cmake/cmake-3.7.2-lto_library.diff"
      sha256 "4c6da40ff59a667ab91b118c4824f3b5795badcb724e2b9118cd1336c02fc6a8"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ebc6de5933ad96a3ccc3764559dd489a7c02588c1485849c540893f28c9a4ae5" => :sierra
    sha256 "d5ba6ead168e5524c10e8409a22d69ed5983b1799e916332b6f27827bf58118b" => :el_capitan
    sha256 "1881ea166e4c7182d357f25c640d564f1e8d342ed658e6c43d95639bb2d60a07" => :yosemite
  end

  devel do
    url "https://cmake.org/files/v3.8/cmake-3.8.0-rc4.tar.gz"
    sha256 "7e271e8a7c8bcdbee957e1fc2ba27e9fe745146d3190d927a8c26e736cb03e32"

    # Remove for > 3.8.0-rc4
    # Same as patch in stable block for https://gitlab.kitware.com/cmake/cmake/issues/16766
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/1b7929e/cmake/cmake-3.8.0-rc4-lto_library.diff"
      sha256 "858789f54b65dc36d2468a24b8092c2cc3a16a753287437b42acaaabbf784583"
    end
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
