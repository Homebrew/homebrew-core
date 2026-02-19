class Mozjpeg < Formula
  desc "Improved JPEG encoder"
  homepage "https://github.com/mozilla/mozjpeg"
  url "https://github.com/mozilla/mozjpeg/archive/refs/tags/v4.1.5.tar.gz"
  sha256 "9fcbb7171f6ac383f5b391175d6fb3acde5e64c4c4727274eade84ed0998fcc1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "ae8b8e5b56ea7d13b5f68225ade34c5e8818d169d8df8a1aa8f12b445dfbe6ff"
    sha256 cellar: :any,                 arm64_sequoia:  "93eea531e7d81f0aade7c403f3e0c65d545d9eade6e0e50bd43bf01cee48f110"
    sha256 cellar: :any,                 arm64_sonoma:   "5254d35ee2814e82b176fa779fc87a69468969dc28f750aaa602d17fd15d1646"
    sha256 cellar: :any,                 arm64_ventura:  "7b364b6311f2a0bcc20c22f66c38eee66427da82fd22293815456ff0f74027da"
    sha256 cellar: :any,                 arm64_monterey: "3b30413d731bd4ad5175dad5e460f6606757ccd4f7d595dd722ce265c839d10d"
    sha256 cellar: :any,                 sonoma:         "fcb0583588eeba6f707aea5899ad93dd5eb49d2982019a4836d817ae0dfbb8bf"
    sha256 cellar: :any,                 ventura:        "db38b13c7efa289ddc6248e3068d3eade4c2314f795650d70bebd6c38d4cca3e"
    sha256 cellar: :any,                 monterey:       "6fddd7081db83c75d0098e0e681c4553b1e6d53fbb88cc744a766552f1f796ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b2ecf43cea49223d6fd0bd8e781ed50e2104eb3fe7e5b4a6ec9ca30cbd87ca94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e69f9e76bf590d31a85839acdc52bbee9b1c4ccef0370f82f5a80e9d21c69298"
  end

  keg_only "it conflicts with the standard libjpeg"

  depends_on "cmake" => :build
  depends_on "nasm" => :build
  depends_on "libpng"

  def install
    args = std_cmake_args - %w[-DCMAKE_INSTALL_LIBDIR=lib]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_LIBDIR=#{lib}", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jpegtran", "-crop", "1x1",
                           "-transpose", "-optimize",
                           "-outfile", "out.jpg",
                           test_fixtures("test.jpg")
  end
end
