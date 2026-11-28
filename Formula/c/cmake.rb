class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.5.1/cmake-4.5.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.5.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.5.1.tar.gz"
  sha256 "a79bf33cbe05686fdf79c2bbbcfe5e8e62ad16d3d540fa737cbedfeed41fb69e"
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
    manifest_sha256 "e6929a2ce3eb2431444a461f7f1397c3b03eb2e2f06018fbfb578036d9c5f40a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "85c89cef809cac14bd5fc155038a878c6caf19b1b6b94382204265e99dc42498"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75374193e7da7edf9aa4b7792aca1a3c8c95b35bd8def890b6bfd50e9ac68918"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c539c1f95ed398d2eef8d3e8f0e5de3e96b918c6af91aa3ad337408adb26d7e"
    sha256 cellar: :any,                 arm64_linux:       "51cdf80e6d6d6cf4373168899755e2ddf2b4c5e8b937844f920fad5c91b0f3e0"
    sha256 cellar: :any,                 x86_64_linux:      "038d3b38795d567f18768b5cd668f4d728804c1490f2fe554e726d132e237097"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

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
