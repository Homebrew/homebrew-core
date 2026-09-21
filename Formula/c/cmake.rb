class Cmake < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v4.4.3/cmake-4.4.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-4.4.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-4.4.3.tar.gz"
  sha256 "c46400618b4f1f2b43507f24fb22f3ae830c3416cf23b776e16e1d413aa892f0"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0687dd7fc33beea223f96946fb64b2dc1345990048b145bc160f9db218b3975"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0a53d2312ce16641029e616591e15dd256258401b401f5663d9560fddf78fc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "49b8b85daec411080b7cfaaaed84846d1e08c366ddb27b199e61ff21cf881646"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "d50416765d0be66fba64b845e9198c9185a9b26a4baea54a50996c3a68b56238"
    sha256 cellar: :any_skip_relocation, tahoe:             "9e321dc7e2f284ece5f048949ad98caeabc9c5fd853c90a1d2c930a33e0bf44e"
    sha256 cellar: :any_skip_relocation, sequoia:           "0422f40c02b98e088ffe0a8f37c6b7efb24ed4f8832cb9efe0e53f97225e586f"
    sha256 cellar: :any_skip_relocation, sonoma:            "f4176e173808ea4a59acb6182ec5bbb0be6fe3e452dbdfd0f8303a6377b13fee"
    sha256 cellar: :any,                 arm64_linux:       "bc56c4bb2c45965103d613f962e9d0ec14989fc9355a908686cfe17532317bef"
    sha256 cellar: :any,                 x86_64_linux:      "b37d85310c00b84eaaa62fa96d51251f6f59fba39e36495eab224f0b76909043"
  end

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
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
