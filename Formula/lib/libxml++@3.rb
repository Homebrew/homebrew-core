class LibxmlxxAT3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.5.tar.xz"
  sha256 "0c9b381b5a83d6b3ab4b0b865d7256dab27d575981b63be2f859edcb94da59c7"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "54ba6ed6a67f9b5c7d41eff654c3aae571203f7c655df54e40cafffa44b1210d"
    sha256 cellar: :any, arm64_sequoia: "5008acc2b89b32ebdeb9324790ba38159cba9056fcc3dda2e8b8870b1469e357"
    sha256 cellar: :any, arm64_sonoma:  "4532af815321f64d165936a020e53748c0e8f2fb4b973fb5e78db08cab3dcfe6"
    sha256 cellar: :any, sonoma:        "21e9caba9dfc62295dc93ccbdefec27b10a82454039ac8205b61cf26bc508c84"
    sha256               arm64_linux:   "12f145b95b67afec328ace9aff3581308ad4782d4978d1c0c00c1350db51cf65"
    sha256               x86_64_linux:  "9d986b3cbb2382d7379e001598db8c6229e2624213c21e4f50c372ed053a644e"
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
