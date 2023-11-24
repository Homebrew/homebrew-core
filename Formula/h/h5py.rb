class H5py < Formula
  desc "Read and write HDF5 files from Python"
  homepage "https://www.h5py.org/"
  url "https://files.pythonhosted.org/packages/37/fc/0b1825077a1c4c79a13984c59997e4b36702962df0bca420698f77b70b10/h5py-3.10.0.tar.gz"
  sha256 "d93adc48ceeb33347eb24a634fb787efc7ae4644e6ea4ba733d099605045c049"
  license "BSD-3-Clause"

  depends_on "libcython" => :build
  depends_on "pkg-config" => :build
  depends_on "python-pkgconfig" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "hdf5"
  depends_on "numpy"

  patch :DATA  # Patch is necessary to compile with cython >= 3.0.0
  # Based on https://github.com/h5py/h5py/compare/master...takluyver:h5py:cython-3

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythonpath = ENV["PYTHONPATH"]
    pythons.each do |python|
      site_packages = Language::Python.site_packages(python)
      ENV.append_path "PYTHONPATH", Formula["libcython"].opt_libexec/site_packages
      ENV.append_path "PYTHONPATH", Formula["python-pkgconfig"].opt_libexec/site_packages
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
      ENV["PYTHONPATH"] = pythonpath
    end
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", <<~EOS
        import io
        import h5py

        bio = io.BytesIO()
        with h5py.File(bio, 'w') as f:
            f['dataset'] = range(10)
        bio.seek(0)
        with h5py.File(bio, 'r') as f:
            assert list(f['dataset']) == list(range(10))

        try:
            bad = h5py.File('/nonexitent/neverexist/nomore.h5')
        except FileNotFoundError:
            assert True
        else:
            assert False
      EOS
    end
  end
end

__END__
diff -ur h5py-3.10.0.orig/h5py/api_types_hdf5.pxd h5py-3.10.0/h5py/api_types_hdf5.pxd
--- h5py-3.10.0.orig/h5py/api_types_hdf5.pxd	2023-10-09 16:16:30.000000000 +0200
+++ h5py-3.10.0/h5py/api_types_hdf5.pxd	2023-11-24 09:54:27.441280355 +0100
@@ -257,27 +257,27 @@
       herr_t  (*sb_encode)(H5FD_t *file, char *name, unsigned char *p)
       herr_t  (*sb_decode)(H5FD_t *f, const char *name, const unsigned char *p)
       size_t  fapl_size
-      void *  (*fapl_get)(H5FD_t *file)
-      void *  (*fapl_copy)(const void *fapl)
-      herr_t  (*fapl_free)(void *fapl)
+      void *  (*fapl_get)(H5FD_t *file) except *
+      void *  (*fapl_copy)(const void *fapl) except *
+      herr_t  (*fapl_free)(void *fapl) except *
       size_t  dxpl_size
       void *  (*dxpl_copy)(const void *dxpl)
       herr_t  (*dxpl_free)(void *dxpl)
-      H5FD_t *(*open)(const char *name, unsigned flags, hid_t fapl, haddr_t maxaddr)
-      herr_t  (*close)(H5FD_t *file)
+      H5FD_t *(*open)(const char *name, unsigned flags, hid_t fapl, haddr_t maxaddr) except *
+      herr_t  (*close)(H5FD_t *file) except *
       int     (*cmp)(const H5FD_t *f1, const H5FD_t *f2)
       herr_t  (*query)(const H5FD_t *f1, unsigned long *flags)
       herr_t  (*get_type_map)(const H5FD_t *file, H5FD_mem_t *type_map)
       haddr_t (*alloc)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size)
       herr_t  (*free)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, haddr_t addr, hsize_t size)
-      haddr_t (*get_eoa)(const H5FD_t *file, H5FD_mem_t type)
-      herr_t  (*set_eoa)(H5FD_t *file, H5FD_mem_t type, haddr_t addr)
-      haddr_t (*get_eof)(const H5FD_t *file, H5FD_mem_t type)
+      haddr_t (*get_eoa)(const H5FD_t *file, H5FD_mem_t type) except *
+      herr_t  (*set_eoa)(H5FD_t *file, H5FD_mem_t type, haddr_t addr) except *
+      haddr_t (*get_eof)(const H5FD_t *file, H5FD_mem_t type) except *
       herr_t  (*get_handle)(H5FD_t *file, hid_t fapl, void**file_handle)
-      herr_t  (*read)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, void *buffer)
-      herr_t  (*write)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, const void *buffer)
-      herr_t  (*flush)(H5FD_t *file, hid_t dxpl_id, hbool_t closing)
-      herr_t  (*truncate)(H5FD_t *file, hid_t dxpl_id, hbool_t closing)
+      herr_t  (*read)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, void *buffer) except *
+      herr_t  (*write)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, const void *buffer) except *
+      herr_t  (*flush)(H5FD_t *file, hid_t dxpl_id, hbool_t closing) except *
+      herr_t  (*truncate)(H5FD_t *file, hid_t dxpl_id, hbool_t closing) except *
       herr_t  (*lock)(H5FD_t *file, hbool_t rw)
       herr_t  (*unlock)(H5FD_t *file)
       H5FD_mem_t fl_map[<int>H5FD_MEM_NTYPES]
@@ -295,27 +295,27 @@
       herr_t  (*sb_encode)(H5FD_t *file, char *name, unsigned char *p)
       herr_t  (*sb_decode)(H5FD_t *f, const char *name, const unsigned char *p)
       size_t  fapl_size
-      void *  (*fapl_get)(H5FD_t *file)
-      void *  (*fapl_copy)(const void *fapl)
-      herr_t  (*fapl_free)(void *fapl)
+      void *  (*fapl_get)(H5FD_t *file) except *
+      void *  (*fapl_copy)(const void *fapl) except *
+      herr_t  (*fapl_free)(void *fapl) except *
       size_t  dxpl_size
       void *  (*dxpl_copy)(const void *dxpl)
       herr_t  (*dxpl_free)(void *dxpl)
-      H5FD_t *(*open)(const char *name, unsigned flags, hid_t fapl, haddr_t maxaddr)
-      herr_t  (*close)(H5FD_t *file)
+      H5FD_t *(*open)(const char *name, unsigned flags, hid_t fapl, haddr_t maxaddr) except *
+      herr_t  (*close)(H5FD_t *file) except *
       int     (*cmp)(const H5FD_t *f1, const H5FD_t *f2)
       herr_t  (*query)(const H5FD_t *f1, unsigned long *flags)
       herr_t  (*get_type_map)(const H5FD_t *file, H5FD_mem_t *type_map)
       haddr_t (*alloc)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size)
       herr_t  (*free)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, haddr_t addr, hsize_t size)
-      haddr_t (*get_eoa)(const H5FD_t *file, H5FD_mem_t type)
-      herr_t  (*set_eoa)(H5FD_t *file, H5FD_mem_t type, haddr_t addr)
-      haddr_t (*get_eof)(const H5FD_t *file, H5FD_mem_t type)
+      haddr_t (*get_eoa)(const H5FD_t *file, H5FD_mem_t type) except *
+      herr_t  (*set_eoa)(H5FD_t *file, H5FD_mem_t type, haddr_t addr) except *
+      haddr_t (*get_eof)(const H5FD_t *file, H5FD_mem_t type) except *
       herr_t  (*get_handle)(H5FD_t *file, hid_t fapl, void**file_handle)
-      herr_t  (*read)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, void *buffer)
-      herr_t  (*write)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, const void *buffer)
-      herr_t  (*flush)(H5FD_t *file, hid_t dxpl_id, hbool_t closing)
-      herr_t  (*truncate)(H5FD_t *file, hid_t dxpl_id, hbool_t closing)
+      herr_t  (*read)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, void *buffer) except *
+      herr_t  (*write)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl, haddr_t addr, size_t size, const void *buffer) except *
+      herr_t  (*flush)(H5FD_t *file, hid_t dxpl_id, hbool_t closing) except *
+      herr_t  (*truncate)(H5FD_t *file, hid_t dxpl_id, hbool_t closing) except *
       herr_t  (*lock)(H5FD_t *file, hbool_t rw)
       herr_t  (*unlock)(H5FD_t *file)
       H5FD_mem_t fl_map[<int>H5FD_MEM_NTYPES]
diff -ur h5py-3.10.0.orig/h5py/h5fd.pyx h5py-3.10.0/h5py/h5fd.pyx
--- h5py-3.10.0.orig/h5py/h5fd.pyx	2023-10-05 13:57:54.000000000 +0200
+++ h5py-3.10.0/h5py/h5fd.pyx	2023-11-24 09:48:50.744656166 +0100
@@ -144,10 +144,10 @@
     stdlib_free(f)
     return 0
 
-cdef haddr_t H5FD_fileobj_get_eoa(const H5FD_fileobj_t *f, H5FD_mem_t type):
+cdef haddr_t H5FD_fileobj_get_eoa(const H5FD_fileobj_t *f, H5FD_mem_t type) noexcept nogil:
     return f.eoa
 
-cdef herr_t H5FD_fileobj_set_eoa(H5FD_fileobj_t *f, H5FD_mem_t type, haddr_t addr):
+cdef herr_t H5FD_fileobj_set_eoa(H5FD_fileobj_t *f, H5FD_mem_t type, haddr_t addr) noexcept nogil:
     f.eoa = addr
     return 0
 
