class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.10/Python-3.12.10.tgz"
  sha256 "15d9c623abfd2165fe816ea1fb385d6ed8cf3c664661ab357f1782e3036a6dac"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "4f832d4f9d8159f5f43965a918ef8ba9ea84a42e4c165eb344d8b319e6585285"
    sha256 cellar: :any, arm64_sonoma:  "a2e2a63a3c42b4e8679b8ae5ec1c996d61eb101fed24a7b119222a856f5291f3"
    sha256 cellar: :any, arm64_ventura: "2ebc6fd91d82f4b92983349a9727feba917f64838b64cc33f273676ef9af1809"
    sha256 cellar: :any, sonoma:        "c08bb26635a9e2e68a1b345dbe6db5c188e304d2acd496b6c9e7cfb89494d206"
    sha256 cellar: :any, ventura:       "df8622d18ffcddcf2cc83f44cab17b35e4dd3284154dff83882ff5ce1ed6da89"
    sha256               arm64_linux:   "1b0e9487ab705bd667c5938d99f73f6e5a4fb0cc9f8de20617eb0e54a5e0a17c"
    sha256               x86_64_linux:  "e2e34bffb1d1eb5b3c7c3e9cff5bdf41d8a991f18927674a5eafa03911626b93"
  end

  depends_on "python@3.12"
  depends_on "tcl-tk"

  def python3
    "python3.12"
  end

  # Apply commit from open PR to fix TCL 9 threaded detection
  # PR ref: https://github.com/python/cpython/pull/128103
  patch do
    url "https://github.com/python/cpython/commit/a2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
  end

  # Backport of https://github.com/python/cpython/commit/47cbf038850852cdcbe7a404ed7c64542340d58a
  # TODO: Remove if https://github.com/python/cpython/pull/124156 is backported to Python 3.12
  patch :DATA

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    cd "Modules" do
      tcltk_version = Formula["tcl-tk"].any_installed_version.major_minor
      Pathname("setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="tkinter",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_tkinter", ["_tkinter.c", "tkappinit.c"],
                          define_macros=[("WITH_APPINIT", 1), ("TCL_WITH_EXTERNAL_TOMMATH", 1)],
                          include_dirs=["#{python_include}/internal", "#{Formula["tcl-tk"].opt_include/"tcl-tk"}"],
                          libraries=["tcl#{tcltk_version}", "tcl#{tcltk_version.major}tk#{tcltk_version}"],
                          library_dirs=["#{Formula["tcl-tk"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
  end

  test do
    system python3, "-c", "import tkinter"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system python3, "-c", "import tkinter; root = tkinter.Tk()"
  end
end

__END__
diff --git a/Lib/tkinter/ttk.py b/Lib/tkinter/ttk.py
index 073b3ae20797c3..8ddb7f97e3b233 100644
--- a/Lib/tkinter/ttk.py
+++ b/Lib/tkinter/ttk.py
@@ -321,6 +321,8 @@ def _tclobj_to_py(val):
     elif hasattr(val, 'typename'): # some other (single) Tcl object
         val = _convert_stringval(val)

+    if isinstance(val, tuple) and len(val) == 0:
+        return ''
     return val

 def tclobjs_to_py(adict):
diff --git a/Modules/_tkinter.c b/Modules/_tkinter.c
index b0b70ccb8cc3d3..45897817a56051 100644
--- a/Modules/_tkinter.c
+++ b/Modules/_tkinter.c
@@ -325,6 +325,7 @@ typedef struct {
     const Tcl_ObjType *ListType;
     const Tcl_ObjType *StringType;
     const Tcl_ObjType *UTF32StringType;
+    const Tcl_ObjType *PixelType;
 } TkappObject;

 #define Tkapp_Interp(v) (((TkappObject *) (v))->interp)
@@ -637,6 +638,7 @@ Tkapp_New(const char *screenName, const char *className,
     v->ListType = Tcl_GetObjType("list");
     v->StringType = Tcl_GetObjType("string");
     v->UTF32StringType = Tcl_GetObjType("utf32string");
+    v->PixelType = Tcl_GetObjType("pixel");

     /* Delete the 'exit' command, which can screw things up */
     Tcl_DeleteCommand(v->interp, "exit");
@@ -1236,7 +1238,8 @@ FromObj(TkappObject *tkapp, Tcl_Obj *value)
     }

     if (value->typePtr == tkapp->StringType ||
-        value->typePtr == tkapp->UTF32StringType)
+        value->typePtr == tkapp->UTF32StringType ||
+        value->typePtr == tkapp->PixelType)
     {
         return unicodeFromTclObj(tkapp, value);
     }
