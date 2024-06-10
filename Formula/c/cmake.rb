class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.5/cmake-3.29.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.5.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.5.tar.gz"
  sha256 "dd63da7d763c0db455ca232f2c443f5234fe0b11f8bd6958a81d29cc987dfd6e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9acc2164efcf035d3365d32b0e55294a2af317861d49a574e0f84050daa06f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480ba5e95b1a2375b1e831a98aa32bf299043d0c5ba3afbc896001a178b16500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50462e22264870e1ba95a13a004b4aa31562303512f02e26c9ad59cfbe207611"
    sha256 cellar: :any_skip_relocation, sonoma:         "6e0276f278c7bdc56968593451c9b3997005896cbba42add1b77201ac75a06ce"
    sha256 cellar: :any_skip_relocation, ventura:        "1dafbeec98b1261d83a98089722c77f1e167b546dde4114ff8371f7b741db823"
    sha256 cellar: :any_skip_relocation, monterey:       "de362cde42b2ca7ede9ecf94ae100159a1ebbe0e5b5943212ce7046550f5317e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84c7f0ff900841703c09912e9366524d12d6b64249839166c667602546198883"
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
