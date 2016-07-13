class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  revision 1

  head "https://cmake.org/cmake.git"

  stable do
    url "https://cmake.org/files/v3.6/cmake-3.6.0.tar.gz"
    sha256 "fd05ed40cc40ef9ef99fac7b0ece2e0b871858a82feade48546f5d2940147670"

    # This patch fixes an incompatibility with hdf5
    # See https://gitlab.kitware.com/cmake/cmake/issues/16190
    patch do
      url "https://gitlab.kitware.com/cmake/cmake/merge_requests/34.patch"
      sha256 "6d47140ebb65c045d9eee2c363aa22e53973a54b9bcdc11ef7b622c97419999f"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "170b93c5c3008c39b3a9090ac5e9976d6ea9566d703c7e6e6c4cdabe29d03a6e" => :el_capitan
    sha256 "2fb7174ab37c11a3088f51b25e59f2847fba2fb9d843354b4a9339685d9853fc" => :yosemite
    sha256 "f90a96be05731509c6f8d9c3fd0bfc39c619a2819eb1a63d0667cfe7e0d6a30d" => :mavericks
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
