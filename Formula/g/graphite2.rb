class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "564c88f3eb3606791d553c4720230f2f67d82e62b9bd5628914eeaa00dc179f9"
    sha256 cellar: :any,                 arm64_sequoia: "931ebffc79a1e2cd5b0f4a1493a4c40773306933bef6f192987435f2684c77e4"
    sha256 cellar: :any,                 arm64_sonoma:  "88ef9a96fb0815b194c1cc19ea094665ec594d54733fca8ed99fd2ba11a403d5"
    sha256 cellar: :any,                 sonoma:        "3871c6bd9b5511974b9e95269cbfe2f58fdd01c85f541707a1863234e983da01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d886ee59d22f32728467a62b8e58532444025db855f4c34aec7a0ef246787ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2fbd85d102a20b10da386b5f00a533ba225726e4a8a53fcbd6664b6f535725b"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freetype" => :build
  end

  def install
    # CMake: Raised required version to 3.5
    cmake_policy_files = %w[CMakeLists.txt src/CMakeLists.txt]
    cmake_files = cmake_policy_files + %w[
      gr2fonttest
      tests/bittwiddling
      tests/json
      tests/sparsetest
      tests/utftest
    ].map { |f| "#{f}/CMakeLists.txt" }

    inreplace cmake_files, "CMAKE_MINIMUM_REQUIRED(VERSION 2.8.0 FATAL_ERROR)", "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)"
    inreplace cmake_policy_files, "cmake_policy(SET CMP0012 NEW)", ""

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "testfont" do
      url "https://scripts.sil.org/pub/woff/fonts/Simple-Graphite-Font.ttf"
      sha256 "7e573896bbb40088b3a8490f83d6828fb0fd0920ac4ccdfdd7edb804e852186a"
    end

    resource("testfont").stage do
      shape = shell_output("#{bin}/gr2fonttest Simple-Graphite-Font.ttf 'abcde'")
      assert_match(/67.*36.*37.*38.*71/m, shape)
    end
  end
end
