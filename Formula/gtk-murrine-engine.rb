class GtkMurrineEngine < Formula
  desc "Murrine GTK+ engine"
  homepage "https://github.com/GNOME/murrine"
  url "https://download.gnome.org/sources/murrine/0.98/murrine-0.98.2.tar.xz"
  sha256 "e9c68ae001b9130d0f9d1b311e8121a94e5c134b82553ba03971088e57d12c89"
  revision 2

  bottle do
    cellar :any
    sha256 "15f0163bd29d64bc306bc60862174d58c61f7fe8f1a369f105c7b3ffa4c5bf06" => :mojave
    sha256 "f83119dad928f2a2dae783d0963c81d72656851ae18df542584fab2e415bf708" => :high_sierra
    sha256 "08bda579c315be5f604086c0e912adab1bc21ae3167031cb081140d1ca34708e" => :sierra
    sha256 "2444bf86ebdf7288a4179bbc7cb4a77b2c8321c901be7d1d1d2430c8fedd1ce8" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-animation"
    system "make", "install"
  end

  test do
    assert_predicate lib/"gtk-2.0/2.10.0/engines/libmurrine.so", :exist?
    assert_predicate share/"gtk-engines/murrine.xml", :exist?
  end
end
