class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.5.tar.bz2"
  sha256 "f7a80575f3724ac3d9b19eaeab802892ece7e4b0061dd6425b4b789353e25425"

  bottle do
    cellar :any
    sha256 "3f3535296b2232448aa2b7509eee7ef65460ccc913475daf0b30b7ab6277e0e1" => :el_capitan
    sha256 "0ed4b80471255f5a6170b7adeae03655c73e828dc6e3eeefeedb1a87f14a9142" => :yosemite
    sha256 "1c7014f27716ce9b8d22423ef0ad79c46eb0a9452f893786a21e018461e0ece1" => :mavericks
    sha256 "99af6d3fd80033e7197ae4aa16db748f2f1078f2e3985a69a55ff58db2a3177a" => :mountain_lion
    sha256 "84195584f1c9d0849bb8aa44b3466b24eee589c39f2a0323ba77fc4033e8e1f8" => :lion
  end

  depends_on "pkg-config" => :build

  resource "xproto" do
    url "https://xorg.freedesktop.org/releases/individual/proto/xproto-7.0.28.tar.gz"
    sha256 "6cabc8ce3fa2b1a2427871167b62c24d5b08a58bd3e81ed7aaf08f2bf6dbcfed"
  end

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.0.tar.bz2"
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
