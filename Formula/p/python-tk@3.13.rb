class PythonTkAT313 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.9/Python-3.13.9.tgz"
  sha256 "c4c066af19c98fb7835d473bebd7e23be84f6e9874d47db9e39a68ee5d0ce35c"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "05b420881a6f7ebcac232c3aa607e577b46add5972bdf7d1913861fe50f36673"
    sha256 cellar: :any, arm64_sequoia: "7dde8b8ebd7fccf9e81c2e4c6b4c927f36b4b35b75bbf7670f27fa927da459a0"
    sha256 cellar: :any, arm64_sonoma:  "330ccdf0ec7e9923d10941a68867d8f1ef27aa6aa8a3b9dcd8eac8e5feedf06f"
    sha256 cellar: :any, sonoma:        "dd6da0d9ce30b0e7a418e328ae007588aaec3ea7892e18857ee6c1595292a5e0"
    sha256               arm64_linux:   "84168c269d5216c43eda64df8b75ec82e8090f58b2ae4008a83b1c60cbddfc0b"
    sha256               x86_64_linux:  "eb220e502a409282e6615a41ae0f1b7e605435edc0c3dd4b68226074394e5e65"
  end

  depends_on "python@3.13"
  depends_on "tcl-tk"

  def python3
    "python3.13"
  end

  # Apply commit from open PR to fix TCL 9 threaded detection
  # PR ref: https://github.com/python/cpython/pull/128103
  patch do
    url "https://github.com/python/cpython/commit/a2019e226e4650cef35ebfde7ecd7ce044a4a670.patch?full_index=1"
    sha256 "03c4b6a293d4a51f534858657717bdc1465c42acb3b78e64c41f9011f966e449"
  end

  # Backport of https://github.com/python/cpython/commit/47cbf038850852cdcbe7a404ed7c64542340d58a
  # TODO: Remove if https://github.com/python/cpython/pull/127364 is merged and released
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
