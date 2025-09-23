class Icemon < Formula
  desc "Icecream GUI Monitor"
  homepage "https://kfunk.org/tag/icemon/"
  url "https://github.com/icecc/icemon/archive/refs/tags/v3.3.tar.gz"
  sha256 "3caf14731313c99967f6e4e11ff261b061e4e3d0c7ef7565e89b12e0307814ca"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:  "61b7f50cdc52d8f6f4eddc624b469c9cd49156c5c6204395b84dff8674c7567b"
    sha256 cellar: :any,                 arm64_ventura: "b88d2b0738b3514d76a232fdb95dfb2895e25cd50328518d10944e29a8972932"
    sha256 cellar: :any,                 sonoma:        "a53d4a690cd9a53f921e18bb2884b65c324fec8ce99903bb7f09a001c9c7ca24"
    sha256 cellar: :any,                 ventura:       "d69c741ab8a85b9ce7c6fe3817d25b16abd6fefcdd17c83aa04ae6027d7d013f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "623a817bb87eb94ad8ae250cfe74c1153545aa13d8813a4719f54d8fd3439f22"
  end

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build

  depends_on "icecream"
  depends_on "lzo"
  depends_on "qt"
  depends_on "zstd"

  on_macos do
    depends_on "libarchive"
  end

  on_linux do
    depends_on "libcap-ng"
  end

  # Backport fix for CMake 4
  patch do
    url "https://github.com/icecc/icemon/commit/b07bf3eb0c28ac5cd527d3ab675d2273d1866b48.patch?full_index=1"
    sha256 "015098bad42e0b020dfefa2fbc8287fa1eb054576ab642b85818ac36cd0755de"
  end

  # Backport support for Qt 6
  patch do
    url "https://github.com/icecc/icemon/commit/d0969453c7d4467e22dcff0f218b31e81136afbe.patch?full_index=1"
    sha256 "ea808f5daba80a6c92c45f661a53c67742df513cfee430fe724819daab8d551a"
  end

  def install
    # Workaround for std::unary_function usage
    # Issue ref: https://github.com/icecc/icemon/issues/80
    ENV.append "CXXFLAGS", "-D_LIBCPP_ENABLE_CXX17_REMOVED_UNARY_BINARY_FUNCTION" if ENV.compiler == :clang

    args = ["-DECM_DIR=#{Formula["extra-cmake-modules"].opt_share}/ECM/cmake"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    if OS.mac?
      system bin/"icemon", "--version"
    else
      output = shell_output("#{bin}/icemon --version 2>&1", 134)
      assert_match "qt.qpa.xcb: could not connect to display", output
    end
  end
end
