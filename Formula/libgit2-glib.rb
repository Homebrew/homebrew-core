class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.2.tar.xz"
  sha256 "2ad6f20db2e38bbfdb6cb452704fe8a911036b86de82dc75bb0f3b20db40ce9c"
  revision 1

  bottle do
    sha256 "3f54034bdc3f924e2755c7b70237bcca02d4360d40dd078f515636f5d76ad37a" => :high_sierra
    sha256 "24e9475134d69efaa3b4da3e993040af6c31ac790167d779c3b8700009f021c6" => :sierra
    sha256 "7d29be8d0f0c8275a0d5d7a2cbb7bb68375f4476b2a1776f6e05f0902db10f04" => :el_capitan
  end

  head do
    url "https://github.com/GNOME/libgit2-glib.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
  end

  deprecated_option "with-python" => "with-python@2"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libgit2"
  depends_on "glib"
  depends_on "vala" => :optional
  depends_on "python@2" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
    ]

    args << "--enable-python=no" if build.without? "python@2"
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
