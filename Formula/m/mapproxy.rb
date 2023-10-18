class Mapproxy < Formula
  include Language::Python::Virtualenv

  desc "Accelerating web map proxy"
  homepage "https://mapproxy.org/"
  url "https://files.pythonhosted.org/packages/65/0e/f3ecc15f1f9dbd95ecdf1cd3246712ae13920d9665c3dbed089cd5d12d3b/MapProxy-1.16.0.tar.gz"
  sha256 "a11157be4729d1ab40680af2ce543fffcfebd991a5fa676e3a307a93fbc56d6b"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "b5c14d783b11413e42b2d03577485ee70d1b10ea1ffc05371b559aafa938c214"
    sha256 cellar: :any,                 arm64_ventura:  "687a7c9e3fb4149243698809b029d8af44daf0c86e29a9355d75e6c11dbd4167"
    sha256 cellar: :any,                 arm64_monterey: "6e34e109fa0a42c3732353863853a9cdfd9ace585e6c6399dfa895c2e277ef8a"
    sha256 cellar: :any,                 sonoma:         "e19b4d8f69457cbd87a66786bce575d0978e471e51a7ba502b55841322578d9e"
    sha256 cellar: :any,                 ventura:        "01109ae42429b2b4070f9aa56bab4b6cdea3c4e749888388b1b279b38d17679e"
    sha256 cellar: :any,                 monterey:       "20442865c78a9f962379811bf8919e405d8a9e08cf623e09558083f390b070c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b48d916430a9594c6f250cd2e7068f7d30a81aa8ad4a794d9e5547fb82acede3"
  end

  depends_on "pillow"
  depends_on "proj"
  depends_on "python-certifi"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "pyproj" do
    url "https://files.pythonhosted.org/packages/38/77/46fe6a107b934fd23b903cb7402b69c8b2480a6cab9481d9f98c6dc7726e/pyproj-3.6.0.tar.gz"
    sha256 "a5b111865b3f0f8b77b3983f2fbe4dd6248fc09d3730295949977c8dcd988062"

    # Patch to build with cython 3+, remove in 3.6.1+
    # upstream commit ref, https://github.com/pyproj4/pyproj/commit/1452ba404be58c14a6b64d4551c320022f5aafcf
    patch :DATA
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"mapproxy-util", "create", "-t", "base-config", testpath
    assert_predicate testpath/"seed.yaml", :exist?
  end
end

__END__
diff --git a/pyproj/_datadir.pxd b/pyproj/_datadir.pxd
index 07ec85f..a5cfd2c 100644
--- a/pyproj/_datadir.pxd
+++ b/pyproj/_datadir.pxd
@@ -1,7 +1,7 @@
 include "proj.pxi"
 
-cpdef str _get_proj_error()
-cpdef void _clear_proj_error()
+cpdef str _get_proj_error() noexcept
+cpdef void _clear_proj_error() noexcept
 cdef PJ_CONTEXT* PYPROJ_GLOBAL_CONTEXT
 cdef PJ_CONTEXT* pyproj_context_create() except *
 cdef void pyproj_context_destroy(PJ_CONTEXT* context) except *
diff --git a/pyproj/_datadir.pyx b/pyproj/_datadir.pyx
index 4675aa3..15439dd 100644
--- a/pyproj/_datadir.pyx
+++ b/pyproj/_datadir.pyx
@@ -6,7 +6,6 @@ from libc.stdlib cimport free, malloc
 
 from pyproj._compat cimport cstrencode
 
-from pyproj.exceptions import DataDirError
 from pyproj.utils import strtobool
 
 # for logging the internal PROJ messages
@@ -79,14 +78,14 @@ def get_user_data_dir(create=False):
     )
 
 
-cpdef str _get_proj_error():
+cpdef str _get_proj_error() noexcept:
     """
     Get the internal PROJ error message. Returns None if no error was set.
     """
     return _INTERNAL_PROJ_ERROR
 
 
-cpdef void _clear_proj_error():
+cpdef void _clear_proj_error() noexcept:
     """
     Clear the internal PROJ error message.
     """
@@ -94,7 +93,7 @@ cpdef void _clear_proj_error():
     _INTERNAL_PROJ_ERROR = None
 
 
-cdef void pyproj_log_function(void *user_data, int level, const char *error_msg) nogil:
+cdef void pyproj_log_function(void *user_data, int level, const char *error_msg) nogil noexcept:
     """
     Log function for catching PROJ errors.
     """
diff --git a/pyproject.toml b/pyproject.toml
index fc3f284..29e91a0 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -1,5 +1,5 @@
 [build-system]
-requires = ["setuptools>=61.0.0", "wheel", "cython>=0.28.4"]
+requires = ["setuptools>=61.0.0", "wheel", "cython>=3"]
 build-backend = "setuptools.build_meta"
 
 [project]
