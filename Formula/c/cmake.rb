class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.3.1/cmake-4.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.3.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.3.1.tar.gz"
  sha256 "0798f4be7a1a406a419ac32db90c2956936fecbf50db3057d7af47d69a2d7edb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53eb2f9408eae51ac642a7a5026c51658455b370ce1399ea1bac4b5cdc519a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "036c1664515b9b96321468c520207f678fd7d0850d88578475a5c1bd71a5dc61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfcfff5e08fc08838dd966167a93d3b7059f949377c12830adcfd079c5af9b67"
    sha256 cellar: :any_skip_relocation, tahoe:         "637ac8abc32662f66001ffa93977421c648724e59996e4bca79fc37915b2c077"
    sha256 cellar: :any_skip_relocation, sequoia:       "4f612d107665840da84ab5eb95f8aaab48dab240856a425c537602742f69ebf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "046bd8864307c950d01316cee50c7ae4505e7e042c33eca62362cdfc5d084413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b27c118ba2a778b078befeb57c390fe822f9f61c596c198203673f2aa59c485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46388e26bcde45c6af54eed554d576dfde7e1a6133eb5957d95e528033998f28"
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
