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
    sha256 "3b309a468fd37f2f5acd86dfdc13ba761a2dba9b3844c67d7a726761408997ff" => :big_sur
    sha256 "fb8f0447f5090363a78aba9bc2d454706b5c0fb509ac7fd5887d1f893640c8ee" => :arm64_big_sur
    sha256 "634724b72b5fcdd54c0bc29bd37bbb00457a4a3762a896f1b743c7d9175c398a" => :catalina
    sha256 "403eba84e98409729480a474508c66b259b4125a80efede453da0021f6893611" => :mojave
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
