class Graphite2 < Formula
  desc "Smart font renderer for non-Roman scripts"
  homepage "https://graphite.sil.org/"
  url "https://github.com/silnrsi/graphite/releases/download/1.3.15/graphite2-1.3.15.tgz"
  sha256 "c6bc8b4252724665297f7cad0c55897285c673f9b8e6db3522ace833593fe0b1"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "MPL-1.1+"]
  head "https://github.com/silnrsi/graphite.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c05e664c8872f3a9e08ada587a33d71b841673126840fe0cd301300c1f59acea"
    sha256 cellar: :any, arm64_sequoia: "bcbf8282acc59c6ed6a0c9a7cf076935735c21de1495bb4e22c3d6bf32f31ee0"
    sha256 cellar: :any, arm64_sonoma:  "f6915c1287d4f867e5ee04d94ae09fef671dcb326b4f19989b85535e34ca87b8"
    sha256 cellar: :any, sonoma:        "fd55694135675287cd54778988e7ea785246ac5bc0ad49a4434b0fcf25e64e4d"
    sha256 cellar: :any, arm64_linux:   "abc633c3193fb03e9817c52fa24ff387e09655471c80864ae6023b9a39354f20"
    sha256 cellar: :any, x86_64_linux:  "2c2803a27eb8365e8c02726d2c2e967496044a9af06e59348b52fef23e8360fd"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freetype" => :build
  end

  def install
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
