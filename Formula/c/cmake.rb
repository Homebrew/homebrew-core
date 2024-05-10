class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.29.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.29.3.tar.gz"
  sha256 "252aee1448d49caa04954fd5e27d189dd51570557313e7b281636716a238bccb"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36b80a88fc65fdd98e3337edee771d484483255edd275bc5c4395bf59cef4264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02828259078b716f8188248cc39b919366d076e3a0801b1761b518a6ea01479c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "991e8b9b2b8eac675444bac9907c8463c5b349740f74abb48a4634644dc69949"
    sha256 cellar: :any_skip_relocation, sonoma:         "e5a1bc0b0ed03fa4939713721db26e80240d6be90cb3ed71e8f590352a818600"
    sha256 cellar: :any_skip_relocation, ventura:        "7fb224813fd3aedde032f8426231f63dd85a30cff995cfcdc7a51c335528611e"
    sha256 cellar: :any_skip_relocation, monterey:       "11b613bf73e4e2253c9aecab8d29f110c19e44ae305372c7c222f0870f9da1ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56c9127340903b856ddfe72ce980927ffb7083246ef4fb61fe42381fc59372aa"
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
