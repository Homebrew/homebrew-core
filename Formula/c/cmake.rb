class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.3/cmake-4.0.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.3.tar.gz"
  sha256 "8d3537b7b7732660ea247398f166be892fe6131d63cc291944b45b91279f3ffb"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6124f0c7ce811d84ee72b8906d82557f33522dcac631aec7206cdfa8c90835ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92655164f419333c09208118dbb2c89d61cc5488de19373302e2b8d3dfec34bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9db96b2241404442d0d49a8c9fd051a43f6080d26b7468e7ddccf332fe584a4d"
    sha256 cellar: :any_skip_relocation, sequoia:       "df8668b731eb910277fa8bd6fb56b8f27b37e8ccdf77d337c7d760778a29f8b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "55a06f768313e23e0914101dd6f5f71589c5c9ae6de94a1a5d96d898570a926c"
    sha256 cellar: :any_skip_relocation, ventura:       "dc93b4885174dc8c41727e97a3e3ef1429d74e66c8923d450f3edf04d9564055"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb9684730c9d663a911f58aec26cb6d5ad0f9b1e722462929d07db018a5a69f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68d09d2c87ea29265b2353d97eb7a416e6448eb2910afe93605c096ce026e41"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  conflicts_with cask: "cmake"

  # The completions were removed because of problems with system bash

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use `brew install --cask cmake`.

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :high_sierra

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
