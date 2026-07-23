class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.0/cmake-4.4.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.0.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.0.tar.gz"
  sha256 "65757f442fdd242e27f1728fc26dc0cba4164f7a0791a5c788631c00080369bc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edf59194430447cb90f3c9b383663091eebdf346d7a58cab45a8777ce15cc6eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "295529a20476ae9d19434f825e5531598f4fe89b663008936ee3f013b3ffbcaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b846e2467be61dff9c69068e5eae9a704ec98eb5b2cb234c737461e2409e84f7"
    sha256 cellar: :any_skip_relocation, tahoe:         "c01a128897cd0a3992deca8200f68ec55717a65b7569c49d0310afb35a407de4"
    sha256 cellar: :any_skip_relocation, sequoia:       "8d8b7f69592e18a51fbe374d252278af813039fa2623831367d13f5ae36aa953"
    sha256 cellar: :any_skip_relocation, sonoma:        "9925b924517f951b95740f673e151fa34c31910864c956e40d46ddcef5f47105"
    sha256 cellar: :any,                 arm64_linux:   "2daa8d57faa9326997f7611ab8fca17117e31b3f33d70dde56fc26fb44377983"
    sha256 cellar: :any,                 x86_64_linux:  "659d5e5ee7b1e1211e384466744fde6f4f92bcb319a64ce4b769ea7a402b1de7"
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
