class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.0.1/cmake-4.0.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.0.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.0.1.tar.gz"
  sha256 "d630a7e00e63e520b25259f83d425ef783b4661bdc8f47e21c7f23f3780a21e1"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fc195bfee6a1a218f792107dcf52da2f49c764dad521367ef8134e65bab442b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff8a06cee1e54ba4bce2a1d8bc81654ee2090a9037cbd323d2d160432b179a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d709ac137ca543c3eb3af98d516a4a321087a57a4c19d0b4b490b8c3176c2b46"
    sha256 cellar: :any_skip_relocation, sequoia:       "09c377a31e872e5f817e3b31d770c23c8c14975c9481da37621dde81411bc313"
    sha256 cellar: :any_skip_relocation, sonoma:        "965132c38bfa0fdb8f8ed287f3c66ce9b689ba3d35de9a619083ecb5aaafb0ca"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b44379ffd02b1e74c9a4b6fb5712940f6bddce83eb6324d3aff28a890971fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "080f7483ffc67e124b6de04623b366512cef0c74962fe8f546ab732684fc7cf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93fea13b3848b9b4d3db0848e4e2db49ebd3564c039d35cafe58754789a77373"
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
