class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.25/libgit2-glib-0.25.0.tar.xz"
  sha256 "4a256b9acfb93ea70d37213a4083e2310e59b05f2c7595242fe3c239327bc565"

  bottle do
    sha256 "a3875f6cff1685ada0b599143fc056493fabeed883a7e090a4cc052ba0f112b2" => :sierra
    sha256 "ac432f38fedea1228635476acbc841e01dd680865f6381d25e67784177f67390" => :el_capitan
    sha256 "0104b532f15fa9cbd971b047ebcabe198efd01679f6cf2e5ba27debc95b6a1a2" => :yosemite
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
