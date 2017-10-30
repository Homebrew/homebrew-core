class Pygobject < Formula
  desc "GLib/GObject/GIO Python bindings for Python 2"
  homepage "https://live.gnome.org/PyGObject"
  url "https://download.gnome.org/sources/pygobject/2.28/pygobject-2.28.6.tar.bz2"
  sha256 "e4bfe017fa845940184c82a4d8949db3414cb29dfc84815fb763697dc85bdcee"
  revision 2

  bottle do
    cellar :any
    sha256 "7fc55d9f1bfcfde11f2f79000362140aac42730069267240aff0d19901e38a32" => :high_sierra
    sha256 "0ceec516a7b336fd0627028db8b09b02a430bc1d063c82c520f914be09af3f2b" => :sierra
    sha256 "4cf2e5b65787d5ef3ddbd31799d6cb0fe8f6bc6366c57433e7e27b479793f6af" => :el_capitan
    sha256 "94eef1d25e5b3cb68fda89d1ad07e2c74103290472d477d6f1943875fcf73df1" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :python

  # https://bugzilla.gnome.org/show_bug.cgi?id=668522
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/pygobject/patch-enum-types.diff"
    sha256 "99a39c730f9af499db88684e2898a588fdae9cd20eef70675a28c2ddb004cb19"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-introspection"
    system "make", "install"
    (lib/"python2.7/site-packages/pygtk.pth").append_lines <<~EOS
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0
    EOS
  end

  test do
    system "python", "-c", "import dsextras"
  end
end
