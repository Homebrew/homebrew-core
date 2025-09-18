class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "https://flif.info/"
  url "https://github.com/FLIF-hub/FLIF/archive/refs/tags/v0.4.tar.gz"
  sha256 "cc98313ef0dbfef65d72bc21f730edf2a97a414f14bd73ad424368ce032fdb7f"
  license "LGPL-3.0-or-later"
  head "https://github.com/FLIF-hub/FLIF.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9f31d2fdf99e6e6a7bc79e1cb303d246a023edae4a4cbab9010c991a42b3f15d"
    sha256 cellar: :any,                 arm64_sequoia: "947265f79e930463ef0e44212cb95aef425b064a9d50abdee3b308c4dc03ab25"
    sha256 cellar: :any,                 arm64_sonoma:  "bdb1164b2c7592791b612169d1ccef5520183da9b9325e8eb9428ede90349f67"
    sha256 cellar: :any,                 sonoma:        "23d44bc668159febffba7d69a39050438097b9abdccd979e604f19463338dc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6d277b41d4575ffc47d7a6db35c7a8ef7eb4a124ac3fc1fed3abeebbfcfb71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe8d950811505c384945d0dd7901010b548cd1f06a59bd6438f2f8417cc01b3"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libpng"
  depends_on "sdl2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", "src", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "doc/flif.pdf"
  end

  test do
    resource "homebrew-test_c" do
      url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
      sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
    end

    testpath.install resource("homebrew-test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_path_exists testpath/"test.png", "Failed to decode test.flif"
  end
end
