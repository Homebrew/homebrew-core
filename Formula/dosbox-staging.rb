class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.75.0.tar.gz"
  sha256 "6279690a05b9cc134484b8c7d11e9c1cb53b50bdb9bf32bdf683bd66770b6658"
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    cellar :any
    sha256 "9a09801ea7b4699eff48acfe05adc51015ef4d0c5baf192d0e52ea1a153c785a" => :catalina
    sha256 "cbb2dcd04d78c41f098c99e72ec52f466ed73ef38b54b2286fe790aabf02a3b0" => :mojave
    sha256 "a32107574d134e7b8cdeda5717307656a086929b2291ea647042beb26e771d0e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
