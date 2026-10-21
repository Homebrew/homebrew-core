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

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b0d0741e077625e3f78334e3d877c5dacbb45f1b7c56050b029b52b0ffe6b0cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "882958ba23fa8075fbb4df3057afc4ebef96342f54c41e2b9f87a51db734224f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6086fe613e55e496651ff30414e41ed8f7cf6ae772c9d3764bcaed2e1244c161"
    sha256 cellar: :any,                 arm64_linux:       "daa34fb4d1bef9545fdcac787031c6628078caba276460c664f0701a5d31e65e"
    sha256 cellar: :any,                 x86_64_linux:      "8b7956e1d2d64701850e5904c41f807ef7f7b74a7c2574c00571bc77674cb0d9"
  end

  depends_on "cmake" => :build
  depends_on "python@3.15"

  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  deny_network_access!

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
