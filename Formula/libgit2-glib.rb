class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.26/libgit2-glib-0.26.2.tar.xz"
  sha256 "2ad6f20db2e38bbfdb6cb452704fe8a911036b86de82dc75bb0f3b20db40ce9c"

  bottle do
    sha256 "41e72a9af021ede5b2d2a6388d87d1a3cf91828257512291b443622973b4fdda" => :high_sierra
    sha256 "20c1bd5ed07328d63aedc9c15c974d3ce970f8a67cfd2fb1d3e5c1471a1d0259" => :sierra
    sha256 "d50c3cfe95b48a7542d79606f1673c9f03cab6653098da2bb9ac4a809546db32" => :el_capitan
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
