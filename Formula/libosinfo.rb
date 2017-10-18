class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://releases.pagure.org/libosinfo/libosinfo-1.1.0.tar.gz"
  sha256 "600f43a4a8dae5086a01a3d44bcac2092b5fa1695121289806d544fb287d3136"

  bottle do
    sha256 "02f47ab456f024842fc123d75733b3dbe11a57d4a4a306c21da83dbcb2ca0c86" => :high_sierra
    sha256 "764ecf89e19d39bf7e6d15d41d22d466893afa462f475582a445ac622aa024f1" => :sierra
    sha256 "d42abc1c79c3bf147bddcada54f1720bca29b18fa573f1d0dbf250ee894bcd97" => :el_capitan
    sha256 "6f2ce2d0cb0725f846644a95bc4701330c1f920d4e1eb3c0683829c2baf5a937" => :yosemite
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
    (testpath/"test.py").write <<~EOS
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
