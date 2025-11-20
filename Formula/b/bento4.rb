class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-641.zip"
  version "1.6.0-641"
  sha256 "8258faf0de7253f2aac016018f33d4a04c16d9060735e14ec8711f84aaedf0c8"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5367dba6956a756d81d778166578f003e29d2509b16e84a8fb0118b8bc387560"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3be0b7e4aa10081340266b8c4ecd5ff536ea75489fc739cfd3948195d94508af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e46e918ac116bfab1bad50f448b816fe75aba44b9f1331dcd01e9f4f8c9d1c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c362b9bfd9caf4a3dfad70c80adb0d5166489c87021c17ee5ffc34ade8a34a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e3cedc1416a3b31db7e328d170bbfd699b6d315ac1930aafbeb67bf283e0533b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79f1631cc68c122870fefb5815f100643587326f7663bfc1ff0b91657c5dc11e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14"

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
