class Libxp < Formula
  desc "X Print Client Library"
  homepage "https://gitlab.freedesktop.org/xorg/lib/libxp"
  url "https://gitlab.freedesktop.org/xorg/lib/libxp/-/archive/libXp-1.0.3/libxp-libXp-1.0.3.tar.bz2"
  sha256 "bd1e449572359921dd5fa20707757f57d7535aff1772570ab2c29c6b49b86266"
  license "MIT"

  livecheck do
    url :stable
    regex(/^libXp[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "15125f120ead5edb95bf231ee97dd9faacd845589e8c12f085e86d53e107dd72"
    sha256 cellar: :any,                 arm64_big_sur:  "d9e17f99eb3a084585f049a3243affb67c0bc494d55ecea910ddbeb6b4c7d79c"
    sha256 cellar: :any,                 monterey:       "e49c62d4d05ac0ed1ff300817124973bd03a0c30160eda4cb18e7d45cdf3c005"
    sha256 cellar: :any,                 big_sur:        "21e04a90fe93b05faeb09b3a7e65c68a3449bcd5596c5df8d21ff1afb22b0a93"
    sha256 cellar: :any,                 catalina:       "e70342d93c5cf690582f559318b05b26da9175fc7620493fa15a224a847ec1da"
    sha256 cellar: :any,                 mojave:         "1cc823e7fe3acb64e58b554e5e956302959f28cb5737eea5c6d15655128aee15"
    sha256 cellar: :any,                 high_sierra:    "8e904b533b4c4264232ae6391e7d4bc37dade77d5d20539ed3d42900ab3950ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81a760a81e1602499f04fd3b9809a73324f4eaec3c521326869ddb824372c88"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxext"

  resource "printproto" do
    url "https://gitlab.freedesktop.org/xorg/proto/printproto/-/archive/printproto-1.0.5/printproto-printproto-1.0.5.tar.bz2"
    sha256 "f2819d05a906a1bc2d2aea15e43f3d372aac39743d270eb96129c9e7963d648d"
  end

  def install
    resource("printproto").stage do
      system "sh", "autogen.sh"
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{prefix}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
    system "sh", "autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags xp").chomp
  end
end
