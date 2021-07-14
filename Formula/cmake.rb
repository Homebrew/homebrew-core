class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.0/cmake-3.21.0.tar.gz"
  sha256 "4a42d56449a51f4d3809ab4d3b61fd4a96a469e56266e896ce1009b5768bd2ab"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2df7efef9c74980f2939671aad9f2abe2e61c3f2721884e62b66a9959c1f1c9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f25b6da69fc8d22fec491d001b9dba3713c8e02dc5c0d90b1d3451d540ec004b"
    sha256 cellar: :any_skip_relocation, catalina:      "3bbc25ea408539cbd51afcdbee6e7405c007c78f68c4da96c13b828c22da18a3"
    sha256 cellar: :any_skip_relocation, mojave:        "02982ea2fac473d7afbe6f6cd4739687dccd405b229b5fdb7c98167f06f7b6ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f4225af26c3dd1e1123964b61e37a0d4acb196e6acf4c923525a7c3aa67f265"
  end

  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@1.1"
  end

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

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
    ]
    on_macos do
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

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
