class PythonTkAT312 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz"
  sha256 "45313e4c5f0e8acdec9580161d565cf5fea578e3eabf25df7cc6355bf4afa1ee"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e6bf4c2a6b46333f6dd3d737c1a269d6ddb0abc17289fe8d281908753d2e28e"
    sha256 cellar: :any,                 arm64_sonoma:  "63296d492944131188db7e397da3055eb2502e1a79d558ee81ff1d784d7add1d"
    sha256 cellar: :any,                 arm64_ventura: "de65feafb6393eb81d71380b8f2d032585b8baa037afcee2f93a20e2a9f77f5a"
    sha256 cellar: :any,                 sonoma:        "2a536d3fc6bfef295a3fe45478b118d3014ca1064fddf84d4846dc716174294b"
    sha256 cellar: :any,                 ventura:       "a8cdb43665f9d496241a33ad699803fb0db407942437ef976d1a21397771daa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43ca8c8c92f4ce2fe97346c3932272d734d199d9f68a48b4ef8092d80dab5328"
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
