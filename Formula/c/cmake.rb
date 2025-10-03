class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.1.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.1.2.tar.gz"
  sha256 "643f04182b7ba323ab31f526f785134fb79cba3188a852206ef0473fee282a15"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9a87dd3bdc0751b398eb60ca9bbbdb35a494478423af6b5a1ecc3594df48f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f6862c61ce225fa3e425ec99d811c70d259b09e5a9fa922f13e9b0aaea9a220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92c8a2a4e305acf797ed64ece87d2bbfe4310acc02422230db10bca7d5a73998"
    sha256 cellar: :any_skip_relocation, tahoe:         "f31908c094e7684d31648b9628181285370bc1532b49a5f8d94e228b82cda8a0"
    sha256 cellar: :any_skip_relocation, sequoia:       "c477caf087157cdc8f27ffd83bbd26b049bd3d6985d4ea04cefe263b293e1ff0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a2400076fd63421f9881b62a333f65ec617aeb3a5a267f237d818142adfc483"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d48b1640ee9d76e6d832d547a41b484abaf60490b9ace68b40b40f3f74f3b2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b65a9e9ca9b0d077cdc02f088936435614deab98c73a1ed974b0875067fdb5b8"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake-app"

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
