class CrispyDoom < Formula
  desc "Limit-removing enhanced-resolution Doom source port based on Chocolate Doom"
  homepage "https://github.com/fabiangreffrath/crispy-doom"
  url "https://github.com/fabiangreffrath/crispy-doom/archive/crispy-doom-5.10.2.tar.gz"
  sha256 "b414636e929af2a16e1fc586101dc378da4a8ad283b339be0749de34cbb3da82"
  license "GPL-2.0-only"

  head "https://github.com/fabiangreffrath/crispy-doom"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "334d6f54742cb84bed5ae85562400b5660232788c59772e8b4a2c8e7bc7f1107"
    sha256 cellar: :any, big_sur:       "e7ff93c49ac5d85a501bf4e12afb56bda7e503f5bf066503a327b35a36f08d32"
    sha256 cellar: :any, catalina:      "9a2d4aeab66d80bef35da79c594c3623ac9fc1e82301e456a9660a57ab857a11"
    sha256 cellar: :any, mojave:        "f36bac4833379ff5e57eb6e87b2375f2c1a7e1b43100fda8abf7a89a23124455"
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
