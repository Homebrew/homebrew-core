class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.6.tar.bz2"
  sha256 "d558a52e8017d984ee59596a9582c8d699a1962391b632bec3bb6804bf4d501c"

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
    url "https://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.31.tar.gz"
    mirror "http://xorg.mirrors.pair.com/individual/proto/xproto-7.0.31.tar.gz"
    sha256 "6d755eaae27b45c5cc75529a12855fed5de5969b367ed05003944cf901ed43c7"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.2.tar.bz2"
    mirror "http://xorg.mirrors.pair.com/individual/util/util-macros-1.19.2.tar.bz2"
    sha256 "d7e43376ad220411499a79735020f9d145fdc159284867e99467e0d771f3e712"
  end

  def install
    resource("xproto").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{buildpath}/xproto"

      # https://github.com/spack/spack/issues/4805#issuecomment-316130729 build fix for xproto
      ENV.deparallelize { system "make", "install" }
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
