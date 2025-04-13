class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-641.zip"
  version "1.6.0-641"
  sha256 "8258faf0de7253f2aac016018f33d4a04c16d9060735e14ec8711f84aaedf0c8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7eb7ebefa4071ee7a67625f7fcbd85d47551ba51028f89ae1d97fbf59830d98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d60460f56f54ce560cc79cc02dcfefc11e7f8a16dace21b3816e3076206debc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc230cd8ae1f04cde434c3b74783a1d1ca7d9ec67c36bea84ff7429e7a3197ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d40c01a5f94bcc32d4a7476e7517ed85a19a95b8f51311246475c1fde2ad432"
    sha256 cellar: :any_skip_relocation, ventura:       "b6cdf83e994059b63c281f1af930101efe7cf9a004d56b4b8964136dddd09679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a92753cbbc9cb5493602ec41aeeed8c2b9588921cf76465f1cb4a915492da680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf92475fac85e78bbf5ead0e87492ee452bb21a70c0c2a270e332c61d12c5f51"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"

  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system bin/"mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_path_exists testpath/"out.mp4", "Failed to create out.mp4!"
  end
end
