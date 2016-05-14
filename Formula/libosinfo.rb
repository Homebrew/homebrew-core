class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://fedorahosted.org/releases/l/i/libosinfo/libosinfo-0.3.0.tar.gz"
  sha256 "538a3468792e919edf5364fe102d751353ae600a92ad3a24f024424a182cefbc"

  bottle do
    sha256 "b07a6866bdd322d8598e0c1b5a81c2a43deecf1cc200a2b453f61c03ba88717c" => :el_capitan
    sha256 "08ca0241c5277d51465ccdbd39776454d24b1b87da88d56f24f9c0d9a59d5a94" => :yosemite
    sha256 "8b481d5cc2feb6296b698fb85c6e546c7dd51aa5073985dfe76a6ded7af563e1" => :mavericks
  end

  depends_on "check"
  depends_on "glib"
  depends_on "intltool" => :build
  depends_on "libsoup"
  depends_on "libxml2"
  depends_on "libxslt"
  depends_on "pkg-config" => :build
  depends_on "pygobject3"
  depends_on "wget" => :build

  depends_on "gobject-introspection" => :optional
  depends_on "vala" => :optional

  # work around "ld: unknown option: --no-undefined"
  # upstream bug: https://bugzilla.redhat.com/show_bug.cgi?id=1305016
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --mandir=#{man}
      --sysconfdir=#{etc}
      --disable-silent-rules
      --disable-udev
      --enable-tests
    ]

    args << "--enable-introspection" if build.with? "gobject-introspection"
    args << "--enable-vala" if build.with? "vala"

    system "./configure", *args

    # Compilation of docs doesn't get done if we jump straight to "make install"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.py").write <<-EOS.undent
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

    system "python", "test.py"
  end
end

__END__
diff -Nu a/osinfo/Makefile.in b/osinfo/Makefile.in
--- a/osinfo/Makefile.in	2016-02-05 18:49:24.000000000 +0800
+++ b/osinfo/Makefile.in	2016-02-05 18:50:09.000000000 +0800
@@ -353,7 +353,7 @@
 MSGMERGE = @MSGMERGE@
 NM = @NM@
 NMEDIT = @NMEDIT@
-NO_UNDEFINED_FLAGS = @NO_UNDEFINED_FLAGS@
+NO_UNDEFINED_FLAGS =
 OBJDUMP = @OBJDUMP@
 OBJEXT = @OBJEXT@
 OTOOL = @OTOOL@
