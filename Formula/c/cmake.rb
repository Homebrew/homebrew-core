class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.4/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.4.tar.gz"
  sha256 "fdeff897b9eb49d764539f2b1edc6eb7e1440df325678a97c1978499e931adda"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57153a33735188968afebfaa33c6f09760e87abb20e8d13034c7e0491b8fc1cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5648b07aa9fefcae2347c2293b87230f89977a8175c9aa25e4ef453199474852"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1276a30a3f7f8defd40c957d0ec4f8df1fcede8d94788d7b01de778e1769c1bb"
    sha256 cellar: :any_skip_relocation, tahoe:         "c4c176ac29045aa72314f6563c827276bcfdc42cd12cfd4f4380dd72e77ae9bd"
    sha256 cellar: :any_skip_relocation, sequoia:       "a10ac458fc4f92c88ceff5ea6d954b84e04b9ceaaa14abb8680a091e7e413982"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4e028b74980910a9a949a9b7ff6e2c09b52311afa2b5e6f1d37236a6ac1db28"
    sha256 cellar: :any,                 arm64_linux:   "3e2c7898dae65acfb80afc75482baeb9549f7cc0ec50a02bfc5b14d4f0d0de6a"
    sha256 cellar: :any,                 x86_64_linux:  "5e9c12e11e9145146204f2d7e8ead6559b748cbcdff3253b68b5158e9f35b630"
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
