class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://cmake.org/files/v3.10/cmake-3.10.1.tar.gz"
  sha256 "7be36ee24b0f5928251b644d29f5ff268330a916944ef4a75e23ba01e7573284"
  head "https://cmake.org/cmake.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fa4888d1d009e32398d0ec312b641f86f6eac53cdfd13e5dae57c07922c8033c" => :high_sierra
    sha256 "5a6c5af53ce59a89d3f31880fdcc169359ec6ad49daa78ebcaf333c32f481590" => :sierra
    sha256 "5e1d7d0abd668e008a695f51778d52b06a229ba6fef5014397f8dab9e4578eca" => :el_capitan
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

    system "./bootstrap", *args, "--", "-DCMAKE_BUILD_TYPE=Release"
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
