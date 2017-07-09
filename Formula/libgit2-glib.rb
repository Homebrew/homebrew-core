class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  revision 1

  stable do
    url "https://download.gnome.org/sources/libgit2-glib/0.25/libgit2-glib-0.25.0.tar.xz"
    sha256 "4a256b9acfb93ea70d37213a4083e2310e59b05f2c7595242fe3c239327bc565"

    # Remove for > 0.25.0
    # Upstream commit from 8 Jul 2017 for libgit 0.26.0 compatibility
    # See https://bugzilla.gnome.org/show_bug.cgi?id=784706
    patch do
      url "https://github.com/GNOME/libgit2-glib/commit/995b33c.patch?full_index=1"
      sha256 "2f878912a5497ce9e27c45c14e512201cde24f3acfdaaae171eddf53d15e4d53"
    end
  end

  bottle do
    sha256 "4e627c1327c45d61a3b5bd0d608b01e21bf4b8fd9b3db47ab2c308297e640840" => :sierra
    sha256 "46b738430e7a042252f01150fb4e52bd978b0a6da586515c908474791713a817" => :el_capitan
    sha256 "580760f5b1310aa1580ed6dd145be5729e4acdc860878d3ecf4a6609c4204a6d" => :yosemite
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
