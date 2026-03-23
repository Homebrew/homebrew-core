class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.0/cmake-4.3.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.0.tar.gz"
  sha256 "f51b3c729f85d8dde46a92c071d2826ea6afb77d850f46894125de7cc51baa77"
  license "BSD-3-Clause"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "480d5663d16d79c17b2dc53499e5b130f595d4d201eaecca9908d2819ec4572b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b54c056ec719849b212642cfaf778d755ccf66c928fd20696ec96c721494690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d77f174a5e615dd661a69db821609b33bdbcfe5ba375e17d36072b58c3cd30b"
    sha256 cellar: :any_skip_relocation, tahoe:         "0faf629febdb727e9ec5cd7024f3e893e32c3d35158110cfd08bc58dfd968a49"
    sha256 cellar: :any_skip_relocation, sequoia:       "b73362997d92e91b0fa0aef682a890fd45d1c3c81382ca471bf566662ef8b503"
    sha256 cellar: :any_skip_relocation, sonoma:        "b247cf26deee8396b480d589fe37e1bfeeb5ef84cbdf9cd9283c16722a1c45b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b177c96f79831ee8d8a7c5303f1c775e367f1ae0d5dcfd9832227a815cfbd10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad05b3280609300511715e57d61c1d37ec67cdc4d09e1b71f568ce4b00cf011"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
