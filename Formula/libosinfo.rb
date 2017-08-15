class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.1.0.tar.gz"
  sha256 "600f43a4a8dae5086a01a3d44bcac2092b5fa1695121289806d544fb287d3136"

  bottle do
    rebuild 1
    sha256 "a47562567ab29bd73b7f8412c66e744092102fcfa9919fff6659adfb5149b2f6" => :sierra
    sha256 "657ba115e5432c8ab9e1262abd8b759fa847d8cded4249ee7681c0a73cddb5fd" => :el_capitan
    sha256 "f15d2fccb9db83969e14a854ec1e3c8c1a4a78ba5e47e638622abcb0fe38edf8" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "check"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "pygobject3"

  depends_on "gobject-introspection" => :recommended
  depends_on "vala" => :optional

  def install
    # avoid wget dependency
    inreplace "Makefile.in", "wget -q -O", "curl -o"

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-silent-rules
      --disable-udev
      --enable-tests
    ]

    args << "--disable-introspection" if build.without? "gobject-introspection"
    if build.with? "vala"
      args << "--enable-vala"
    else
      args << "--disable-vala"
    end

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
      import gi
      gi.require_version('Libosinfo', '1.0')
      from gi.repository import Libosinfo as osinfo;

      loader = osinfo.Loader()
      loader.process_path("./")

      db = loader.get_db()

      devs = db.get_device_list()
      print "All device IDs"
      for dev in devs.get_elements():
        print ("  Device " + dev.get_id())

      names = db.unique_values_for_property_in_device("name")
      print "All device names"
      for name in names:
        print ("  Name " + name)

      osnames = db.unique_values_for_property_in_os("short-id")
      osnames.sort()
      print "All OS short IDs"
      for name in osnames:
        print ("  OS short id " + name)

      hvnames = db.unique_values_for_property_in_platform("short-id")
      hvnames.sort()
      print "All HV short IDs"
      for name in hvnames:
        print ("  HV short id " + name)
    EOS
    ENV.append_path "GI_TYPELIB_PATH", lib+"girepository-1.0"
    ENV.append_path "GI_TYPELIB_PATH", Formula["gobject-introspection"].opt_lib+"girepository-1.0"
    ENV.append_path "PYTHONPATH", lib+"python2.7/site-packages"
    ENV.append_path "PYTHONPATH", Formula["pygobject3"].opt_lib+"python2.7/site-packages"
    system "python", "test.py"
  end
end
