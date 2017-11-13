class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  head "https://cmake.org/cmake.git"

  stable do
    url "https://cmake.org/files/v3.9/cmake-3.9.6.tar.gz"
    sha256 "7410851a783a41b521214ad987bb534a7e4a65e059651a2514e6ebfc8f46b218"

    # The two patches below fix cmake for undefined symbols check on macOS 10.12
    # They can be removed for cmake >= 3.10
    if MacOS.version == :sierra && DevelopmentTools.clang_build_version >= 900
      patch do
        url "https://gitlab.kitware.com/cmake/cmake/commit/96329d5dffdd5a22c5b4428119b5d3762a8857a7.diff"
        sha256 "c394d1b6e59e9bcf8e5db8a0a1189203e056c230a22aa8d60079fea7be6026bd"
      end

      patch do
        url "https://gitlab.kitware.com/cmake/cmake/commit/f1a4ecdc0c62b46c90df5e8d20e6f61d06063894.diff"
        sha256 "d32fa9c342d88e53b009f1fbeecc5872a79eec4bf2c8399f0fc2eeda5b0a4f1e"
      end

      patch do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/105060cf885/cmake/cmake-backport-kwsys-utimensat-fix.diff"
        sha256 "3e8aa1a6a1039e7a9be6fd0ca6abf09ca00fb07e1275bb3e55dc44b8b9dc746c"
      end
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3b23915afa5f01f9c98079444e9f5da256430d72ee75de4f752fcb3f6bec7800" => :high_sierra
    sha256 "42844d3d61d2322642b0c8c4a917dc1b057b47f233b03ba98d45da798bbfa66c" => :sierra
    sha256 "d90e69aa1df7d9fd1e3147c076ce00ed90892e62024fa9df80aeb3bc1e564234" => :el_capitan
  end

  devel do
    url "https://cmake.org/files/v3.10/cmake-3.10.0-rc5.tar.gz"
    sha256 "7c4322f778d0ac67413de0a3217c1638675d4fceab6564c9b448d617d41aedf6"
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
