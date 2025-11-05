class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.net/"
  url "https://download.gnome.org/sources/libxml++/2.42/libxml++-2.42.3.tar.xz"
  sha256 "74b95302e24dbebc56e97048e86ad0a4121fc82a43e58d381fbe1d380e8eba04"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2ae111013e6054a6f75cb5af460b83fad5ddc9ef99bd4852140489053130803c"
    sha256 cellar: :any, arm64_sequoia: "14b1de5dfecf8f74985f32b2024fa403ed2bb97c59843351fac956783468ee67"
    sha256 cellar: :any, arm64_sonoma:  "d0a9d767fd866a1a7b993a5805c09f68ba4cef7f489d97949f7c92b5505ec52d"
    sha256 cellar: :any, sonoma:        "e90b41d9e57fb9e404364f9753a6e05a59a7d4a113f0d7d1a3197116885cc30a"
    sha256               arm64_linux:   "1431cd3ea47beea8cf74e6e37b34e1b19a90e896d7b207f96c4c46649f13eaef"
    sha256               x86_64_linux:  "528fb163b90b28ed96f64e65743c5730ad142ea8ea5fb7a89f43876099da59f1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glibmm@2.66"

  uses_from_macos "libxml2"

  # Fix naming clash with libxml macro.
  # Backport of: https://github.com/libxmlplusplus/libxmlplusplus/pull/74
  patch :DATA

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs libxml++-2.6").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/libxml++/parsers/textreader.cc b/libxml++/parsers/textreader.cc
index 223dd9a..c80b0f4 100644
--- a/libxml++/parsers/textreader.cc
+++ b/libxml++/parsers/textreader.cc
@@ -19,7 +19,7 @@ public:
   int Int(int value);
   bool Bool(int value);
   char Char(int value);
-  Glib::ustring String(xmlChar* value, bool free = false);
+  Glib::ustring String(xmlChar* value, bool should_free = false);
   Glib::ustring String(xmlChar const* value);
 
   TextReader & owner_;
@@ -403,7 +403,7 @@ char TextReader::PropertyReader::Char(int value)
   return value;
 }
 
-Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool free)
+Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool should_free)
 {
   owner_.check_for_exceptions();
   
@@ -412,7 +412,7 @@ Glib::ustring TextReader::PropertyReader::String(xmlChar* value, bool free)
     
   const Glib::ustring result = (char *)value;
 
-  if(free)
+  if(should_free)
     xmlFree(value);
 
   return result;
