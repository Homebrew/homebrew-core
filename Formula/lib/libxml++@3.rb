class LibxmlxxAT3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.5.tar.xz"
  sha256 "0c9b381b5a83d6b3ab4b0b865d7256dab27d575981b63be2f859edcb94da59c7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8913adaf8f40d6a47f8725d9522c2a5a5cba3bb2f339f68968d7233b98d63506"
    sha256 cellar: :any, arm64_sequoia: "a44be374982b3a3b7adb3c13f31c97feb882b6268b85fb337b3a30980f0a9531"
    sha256 cellar: :any, arm64_sonoma:  "6cb350dd2f4c0d81c9ca84395a31d0ca9d89e8331b175cef126678c758dcb9ca"
    sha256 cellar: :any, arm64_ventura: "93b3ed88b404c4d7897789a37fa78a5798b395916a4753a1ab4b5df53ae83439"
    sha256 cellar: :any, sonoma:        "04fe9da87109a92954ffa01cd5d7cb02356d6e1d6a7526240af5bf92c0836920"
    sha256 cellar: :any, ventura:       "1ce4596e40a056ceffebf9d53e9d1af0c1dd1b392590a5c528412eeb8093ea12"
    sha256               arm64_linux:   "4c076e487be6a8ab63d8bc581a94769a5f720265c2991fd56182b034c70d8c09"
    sha256               x86_64_linux:  "982a460245b85912af6064eec18e6fc0a1bd9cc42f96a949df9d309640a5088c"
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
    command = "#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml++-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/libxml++/parsers/textreader.cc b/libxml++/parsers/textreader.cc
index 75a2c68..65dec5f 100644
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
