class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-6.0.tar.gz"
  sha256 "2b1462d9fb4600cdd4cb77d77f6559dd2d50d0fe0f023dcc09a2b3eefa740cbe"
  license "GPL-2.0-only"
  head "https://github.com/fabiangreffrath/crispy-doom.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2855e863cdf9d4a8146b5c038f34c6e74fd53c4345523d272cc0f8a3e37d4196"
    sha256 cellar: :any,                 arm64_monterey: "98ab23e5fa5e41fbbaa4edb76cac16a9ebd63b120071f052f5f016f53b6899cd"
    sha256 cellar: :any,                 arm64_big_sur:  "8d8ea7cd0d40dcee1c817651d89495f214545180c2e86986e5d4ea36b3d8c3ef"
    sha256 cellar: :any,                 ventura:        "0cf3aede962f8d139869f72225c595def7c57e28dee6b62e96e5fe19583e01ae"
    sha256 cellar: :any,                 monterey:       "fe22e1db3134a829a6069bfdb0370f28aaa6eac10451c1aec91ea2559f07e084"
    sha256 cellar: :any,                 big_sur:        "2110f48674a1ee3eefe57b2813d05c5e57087c2f1b91530dc43242dfcbe09eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e254a4b084d729cfb45780a1bf5ad439106f7feed1451805d524ab0834f4dacb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
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
      Inavlid IWAD file
    EOS
    (testpath/"test_invalid.wad").write testdata

    expected_output = "Wad file test_invalid.wad doesn't have IWAD or PWAD id"
    assert_match expected_output, shell_output("#{bin}/crispy-doom -nogui -iwad test_invalid.wad 2>&1", 255)
  end
end
