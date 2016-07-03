class Libosinfo < Formula
  desc "The Operating System information database"
  homepage "https://libosinfo.org/"
  url "https://fedorahosted.org/releases/l/i/libosinfo/libosinfo-0.3.1.tar.gz"
  sha256 "50b272943d68b77d5259f72be860acfd048126bc27e7aa9c2f9c77a7eacf3894"

  bottle do
    sha256 "7109a6389742daa4b9c3946d41fa062613e681c9bdfa18af936872a2f270f8a5" => :el_capitan
    sha256 "adb697520fee4ca251f9a56b3119ed3eed1ac83839804cd486002e1ecf70f52c" => :yosemite
    sha256 "f39179801faa67e260672bcaa07406bad710283894d50e26838bb57c5a58b12a" => :mavericks
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
