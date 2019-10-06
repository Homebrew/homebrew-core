class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  mirror "http://xorg.mirrors.pair.com/individual/util/makedepend-1.0.5.tar.bz2"
  sha256 "f7a80575f3724ac3d9b19eaeab802892ece7e4b0061dd6425b4b789353e25425"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "83c50101b3f5165bcd2b62e21f536c9f0375a4b35a554f79b6c1ce7b2d19b68d" => :catalina
    sha256 "f8fe4a9c0346e86c2a8b675a1818f21024a28c8bd228c2eb2b47c90179705531" => :mojave
    sha256 "648d18f27ef8ea0067a1d315ac9ffedece1734d950fa1228175ddd6f04c02ecf" => :high_sierra
    sha256 "9e56751537ccf63d38f7d44c34cdcc565895a774d6f81d844c4900e008399712" => :sierra
    sha256 "0f13329fdaa980ab3e4440f352a70e99aa3afdcfba0ad9bc60e9bc2e828f1b3b" => :el_capitan
    sha256 "18186e2c1dbd9ea5b8107f4987318e9a75c87d2195e98238e216d8554c410138" => :yosemite
    sha256 "afe9b0203383cd9a180c4f247fbf26c2a4bc75a7324963c95f6e9ebc39f1d806" => :mavericks
  end

  depends_on "pkg-config" => :build

  resource "xproto" do
    url "https://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.28.tar.gz"
    mirror "http://xorg.mirrors.pair.com/individual/proto/xproto-7.0.28.tar.gz"
    sha256 "6cabc8ce3fa2b1a2427871167b62c24d5b08a58bd3e81ed7aaf08f2bf6dbcfed"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.0.tar.bz2"
    mirror "http://xorg.mirrors.pair.com/individual/util/util-macros-1.19.0.tar.bz2"
    sha256 "2835b11829ee634e19fa56517b4cfc52ef39acea0cd82e15f68096e27cbed0ba"
  end

  def install
    resource("xproto").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{buildpath}/xproto"
      system "make", "install"
    end

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xproto/lib/pkgconfig"
    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end
