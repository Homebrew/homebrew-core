class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.2.tar.xz"
  sha256 "2ad6f20db2e38bbfdb6cb452704fe8a911036b86de82dc75bb0f3b20db40ce9c"

  bottle do
    sha256 "75bd2fc38577f01574ccfd85458cedb8debb755c2e6a4ba0856c8a0a2400125b" => :high_sierra
    sha256 "90dde630fbbcbb46fb44c21cf45c711546fe880010f4fe45c4467d878db41574" => :sierra
    sha256 "57abc504662879a7ef9267eb3a1474fa5192171367f855aef25ca1dfaefa7102" => :el_capitan
    sha256 "d907f60a9bdd7363ae876394bf0ab9c99cbb8e51a24738d2d1a1bd2c9f598edd" => :yosemite
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
