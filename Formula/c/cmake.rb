class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.28.1/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.28.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.28.1.tar.gz"
  sha256 "15e94f83e647f7d620a140a7a5da76349fc47a1bfed66d0f5cdee8e7344079ad"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bd4f2a2af71bf43383e9890f7d72fd0f6da681a3c47eec7c9bcaaf1dd8391d07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8caebdd116476b20de9189eb23bfc8d83c560a75281577da4f250687aa3eb05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78d4d3bf9ad02abef5a3d8ce01e4aac8f5c1a722f19642b4697a03abec6ec699"
    sha256 cellar: :any_skip_relocation, sonoma:         "dec9f52d57eeb446b067e59d84d6f041f309ff2f1d4b0a90483927ff7f0042d6"
    sha256 cellar: :any_skip_relocation, ventura:        "cf732d075da2017f546db144f8ea1106416febb891ba7aca2ffcba1fb99d8ffd"
    sha256 cellar: :any_skip_relocation, monterey:       "6de45cd8b268c91ebaa152d1422e31ceb3d972e8ac0b9b793937819d1fbff240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b60a9c926aaba85024aa15ef89907204d26099c5a5af11e59b920cc572202a4e"
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
