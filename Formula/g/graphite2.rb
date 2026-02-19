class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.14/graphite2-1.3.14.tgz"
  sha256 "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "a5645201ace59a1ee7c24d075adf37ae1965018b41221062e8088b191763334d"
    sha256 cellar: :any,                 arm64_sequoia: "a805dafe03fc697a0d2157a92d110be687f7136d360a483ca43c8f81cdfe4852"
    sha256 cellar: :any,                 arm64_sonoma:  "1a57783f066cfb70115517438457ded104ecbb2d908586c58ebe0d6cd6117995"
    sha256 cellar: :any,                 sonoma:        "1c40aed095158f418a818939a8398afab628147ec2bad529868d3f6fd1990f23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acc9b3af3f19b1246163a990bf74bec6b88f44f5c511ac70f0d73d6103b012ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cdf99ed424bacc35f62e84ff807fef46263a543be38c479a7f4a6bd180ab705"
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

    inreplace lib/"pkgconfig/graphite2.pc", prefix.realpath, opt_prefix
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
