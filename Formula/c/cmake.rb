class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.2/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.2.tar.gz"
  sha256 "b0231eb39b3c3cabdc568c619df78208a7bd95ea10c9b2236d61218bac1b367d"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, and
  # there have been delays between the creation of a tag and the corresponding
  # release, so we check the website's downloads page instead.
  livecheck do
    url "https://cmake.org/download/"
    regex(/href=.*?cmake[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40fa7ab6cbb1340bca9c5101d65f852edb56b990a3e335efa735cc1743884570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6566c414e096a60c61dce97735b50f93e993919d3b96f66b88fd6e140e329aa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cdd3973aed8ad832afc2c45297778b260125be439dafd0c28186ab55fb3a035"
    sha256 cellar: :any_skip_relocation, tahoe:         "dea3acb4151222accb9c725617b2e026f9beea4bd7f04b470669f0abc8d59719"
    sha256 cellar: :any_skip_relocation, sequoia:       "0788b1d6335a68adba92be661f52172cd01c3a03fc744ce5f4c4ae2e4e811fd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4578fdc25324c25aba44fa64a653b3e6f107dc73e57e87c8df86e7970d43d173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751731dfc991820d8fe786624daecae18f023063fa3732957e99469a268704c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "283fffb90211cdf24904e4a99ece378592bcf8b852f42eefad021ec0659cedff"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4"
  end

  conflicts_with cask: "cmake-app"

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

    # Move ctest completion because of problems with macOS system bash 3
    (share/"bash-completion/completions").install bash_completion/"ctest"
  end

  def caveats
    <<~EOS
      To install the CMake documentation, run:
        brew install cmake-docs
    EOS
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION #{version.major_minor})
      find_package(Ruby)
    CMAKE
    system bin/"cmake", "."

    # These should be supplied in a separate cmake-docs formula.
    refute_path_exists doc/"html"
    refute_path_exists man
  end
end
