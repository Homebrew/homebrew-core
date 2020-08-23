class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.75.1.tar.gz"
  sha256 "9155cc7220e612817670fbe51f30c69e560573f1daad075037194f2731a538a8"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    cellar :any
    sha256 "603159158713476aedba2bb3b628ef787e34a677831f3db7e864228475b2680c" => :catalina
    sha256 "c4c337d0eab984edb1eeedeb3871312124af026fdbe9eec32bd7c60bc8b2a1e0" => :mojave
    sha256 "c3323334f64f3a999299fbcf3d6322b0ea6ef6e932b51ee8738b913f0f3b1036" => :high_sierra
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
