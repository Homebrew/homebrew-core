class Mad < Formula
  desc "MPEG audio decoder"
  homepage "https://codeberg.org/tenacityteam/libmad"
  url "https://codeberg.org/tenacityteam/libmad/releases/download/0.16.5/libmad-0.16.5.tar.gz"
  sha256 "f401b2ccf49c26ad0c3a6ef0179b1cbbff2406338b0603bb2033e6dcaf706114"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "b27f2d1b0265c6efa3d5af77f303aef8b47753bc69ac9d4060b19ad9126b0102"
    sha256 cellar: :any, arm64_tahoe:       "0fcfb44bdf6c65c9d3578114baaaae4f3a2a7cad32d5985974d4bf5cb499d2d0"
    sha256 cellar: :any, arm64_sequoia:     "d897ca79730bce903a767a9cd310dfa9a18d0df0bb8b483541197264c6cbff3a"
    sha256 cellar: :any, arm64_linux:       "cb79367bd046df2fbbcf6149ba040f2e345c445c1c8c0abe52d3c28fb878e7ff"
    sha256 cellar: :any, x86_64_linux:      "b48a4fbf2823cf570cbc1ba7afe186d9f53456a39d4ddc29b24fe2aee99c048d"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DEXAMPLE=OFF",
                    "-DCMAKE_INSTALL_NAME_DIR=#{opt_lib}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/minimad.c"
  end

  test do
    system ENV.cc, pkgshare/"minimad.c", "-o", "minimad", "-I#{include}", "-L#{lib}", "-lmad"
    system "./minimad <#{test_fixtures("test.mp3")} >test.wav"
    assert_equal 4608, (testpath/"test.wav").size?
  end
end
