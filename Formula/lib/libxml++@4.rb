class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/4.2/libxml++-4.2.0.tar.xz"
  sha256 "898accd9c6fa369da36bfebb5fee199d971b86d26187418796ba9238a6bd4842"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8a4f4f5422ef18c15e06258c50b4abb86f77359639b9799aab1c4898f3553a25"
    sha256 cellar: :any, arm64_sequoia: "2ddd9704aedbbb06275db9feeec79f1513a82480e8810514a10ca843dfcd01f7"
    sha256 cellar: :any, arm64_sonoma:  "963f340b83ba711f769a78d78897f1c1fe083b86cad7f16ffa746cf4cf2dd599"
    sha256 cellar: :any, sonoma:        "8646196252e15695ee73aed4d3df3608520099057a937daa076f8f1a711a25b2"
    sha256               arm64_linux:   "a6ba92468426a91bc330aa33a9cd23556b52d1a7cccdbc004fb33115766edc1b"
    sha256               x86_64_linux:  "3294b3a20fef0cfffdf4062291d1b7fe8ac9e969258e2b3b41812a3219d8c903"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glibmm"

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
    command = "#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
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
