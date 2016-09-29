class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.24/libgit2-glib-0.24.4.tar.xz"
  sha256 "3a211f756f250042f352b3070e7314a048c88e785dba9d118b851253a7c60220"
  revision 1

  bottle do
    sha256 "5bdad256a9562f73998e774adfc365fa16b3ed3a7d04f426906e44ccd95e34f2" => :sierra
    sha256 "641b3e4494b86f6ead4fedd260b6ff7e1477ed253d1e3e1870e4e07e26457e98" => :el_capitan
    sha256 "dd438cd28d5a7e398dad1b25795cb73d7df383abe91e569987996bcba59b6a5d" => :yosemite
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
