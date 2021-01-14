class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.76.0.tar.gz"
  sha256 "7df53c22f7ce78c70afb60b26b06742b90193b56c510219979bf12e0bb2dc6c7"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    cellar :any
    sha256 "b37ecd076e7c70fbf4b4937901c75d689ee1a0112d9b25666e59a371ffa94c46" => :big_sur
    sha256 "623009fa09278f6cc329b5f4bbc81e755ad154a8e1e17bc9add655277a68f2ac" => :arm64_big_sur
    sha256 "d2d1289f2495e0c566ff470b6d4996762fc4a73be6d7ce8c11aa5417c3832be3" => :catalina
    sha256 "92c576540030e27e47f6295f2b0477632301492862dcf8303b5bf2b71ffe8229" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libpng"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
    mv bin/"dosbox", bin/"dosbox-staging"
    mv man1/"dosbox.1", man1/"dosbox-staging.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
