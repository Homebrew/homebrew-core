class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-6.0.tar.gz"
  sha256 "2b85649c615efeac7573883370e9434255af301222b323120692cb9649b7f420"
  license "GPL-2.0-only"
  revision 1

  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be4ceab9e1cb7a1563e57c654a90ee309948b47e719aecc7426fbabef2f0ec52"
    sha256 cellar: :any,                 arm64_ventura:  "19e4f1a6e23950ec922e672be298e8ca8d702e503f85d51a9da64ee4083dc314"
    sha256 cellar: :any,                 arm64_monterey: "9902a1e17493c3a05ef1eee4f20cd9182667ff89fb062988894eacf8af9fc6ec"
    sha256 cellar: :any,                 arm64_big_sur:  "5efe0048088ffb5ee12472407d421a9712bca17eb8e47686bd9b7e647e8db1de"
    sha256 cellar: :any,                 sonoma:         "41df7efb26c6c9b99f2e2e980ac99490e05aa6436ccf1b358531fe602fac8be1"
    sha256 cellar: :any,                 ventura:        "8d4a9d5c429d7352e683af1cfe2469d3509a156a764d4c5fc4dd4dd58c5f5acb"
    sha256 cellar: :any,                 monterey:       "793f15b76ec873e43f0365683644163d017d3f17ad179d63bd820c498ad85a21"
    sha256 cellar: :any,                 big_sur:        "314dce30413f43e4f7cf986896e89fa3abcc4d9dcf4922f3cf12320a43d17663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2812bfd3721d746017e624485ee9a9e57fcdf8e479d061ad3acfbea9cd03535"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sdl2_net"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-sdltest"
    system "make", "install", "execgamesdir=#{bin}"
  end

  test do
    testdata = <<~EOS
      Invalid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/crispy-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
