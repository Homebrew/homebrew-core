class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.24/libgit2-glib-0.24.3.tar.xz"
  sha256 "0c4f781d293a57758a81d67e22964e78389f7a4e860ac37c86788a763a625969"

  bottle do
    sha256 "cfa01d9f5c9a2d950b8a1e56a9c447e4928f688ba5cfe3d99eeca03bae50f087" => :el_capitan
    sha256 "801c28e332d26b05a842ed3fda1a75e9241dc9f5a315f60cc9af348a5c396f35" => :yosemite
    sha256 "663e32fc42661de2d385028f09fbac0d59899f8084f3982288de09440f6700da" => :mavericks
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2"
  depends_on "gobject-introspection"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on :python => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python"
    args << "--enable-vala=no" if build.without? "vala"

    system "./autogen.sh", *args if build.head?
    system "./configure", *args if build.stable?
    system "make", "install"

    libexec.install "examples/.libs", "examples/clone", "examples/general", "examples/walk"
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end
