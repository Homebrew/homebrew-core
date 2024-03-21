class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.4/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.4.tar.gz"
  sha256 "eb9c787e078848dc493f4f83f8a4bbec857cd1f38ab6425ce8d2776a9f6aa6fb"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "402dbe8f6789acc8d87e42dfa136059810d8b151562efe21dc2dbc9ea88131e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ec583d4c1280f86312a20cd2374d09f67fce3588d7a01ee48e99409577e9002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a6eb72877e91e26617d7cbe1240f2213f1abbc1b48c3cbdb6875fbb5500eb11"
    sha256 cellar: :any_skip_relocation, sonoma:         "0045b5fdbb139e1f91f5370a9bcf0a409434a088e4824cddb6539f03adcdf77b"
    sha256 cellar: :any_skip_relocation, ventura:        "82a0485ff08d62a32ac08f228c6aad3c816668ee2d61885d6edbe15c7f0bbc59"
    sha256 cellar: :any_skip_relocation, monterey:       "36dfd9efbc80c7e97aa73bb2c89987cd5ee312d1ce1c019aa761969e16ed8614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b4fb1e54014a2b81f17518d2a467af5ffa117d094810ca139577c0231c0c12"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
                                       "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
                                       "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
                                       "-DCMake_BUILD_LTO=ON"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
