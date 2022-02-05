class Chapel < Formula
  desc "Programming language for productive parallel computing at scale"
  homepage "https://chapel-lang.org/"
  url "https://github.com/chapel-lang/chapel/releases/download/1.25.1/chapel-1.25.1.tar.gz"
  sha256 "0c13d7da5892d0b6642267af605d808eb7dd5d4970766f262f38b94fa2405113"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_monterey: "229f22e29b0cc7a904841636c924d0c94c00299f817ed294247957d43c128cf3"
    sha256 arm64_big_sur:  "9f4a5b7644f18da492f75b4442bc7e22d0b59fa72d6952b15f14f15a2949f57b"
    sha256 monterey:       "bd3d8c066ce51d66b44e0430fc12f01ce5b99701f337304bf609b185bdbdefec"
    sha256 big_sur:        "20b698193b5f7efb99c0eee60126a3e47a420fe99a65ed83aba919fac1cfacac"
    sha256 catalina:       "8eeb73c3884680831146792096af481b1f2c23902eed1ad798f3aa890d2a1e49"
    sha256 x86_64_linux:   "f351e793925739313b0025b6e90287688da278ebe60191000b5a6e5e239b60ef"
  end

  depends_on "gmp"
  depends_on "llvm@11"
  depends_on "python@3.10"

  # Include changes for Python 3.10 migration
  # They are already merged upstream after 1.25.1
  # TODO: Remove this in the next release
  patch :DATA

  def install
    libexec.install Dir["*"]
    # Chapel uses this ENV to work out where to install.
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_GMP"] = "system"

    # Must be built from within CHPL_HOME to prevent build bugs.
    # https://github.com/Homebrew/legacy-homebrew/pull/35166
    cd libexec do
      system "echo CHPL_RE2=bundled > chplconfig"
      system "echo CHPL_GMP=system >> chplconfig"
      system "echo CHPL_LLVM_CONFIG=#{HOMEBREW_PREFIX}/opt/llvm@11/bin/llvm-config >> chplconfig"
      system "./util/printchplenv", "--all"
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "test-venv"
      end
      with_env(CHPL_LLVM: "none") do
        system "make"
      end
      with_env(CHPL_LLVM: "system") do
        system "make"
      end
      with_env(CHPL_PIP_FROM_SOURCE: "1") do
        system "make", "chpldoc"
      end
      system "make", "mason"
      system "make", "cleanall"
      rm_rf("third-party/llvm/llvm-src/")
      rm_rf("third-party/gasnet/gasnet-src")
      rm_rf("third-party/libfabric/libfabric-src")
      rm_rf("third-party/fltk/fltk-1.3.5-source.tar.gz")
      rm_rf("third-party/libunwind/libunwind-1.1.tar.gz")
      rm_rf("third-party/gmp/gmp-src/")
      rm_rf("third-party/qthread/qthread-src/installed")
    end

    # Install chpl and other binaries (e.g. chpldoc) into bin/ as exec scripts.
    platform = if OS.linux? && Hardware::CPU.is_64_bit?
      "linux64-#{Hardware::CPU.arch}"
    else
      "#{OS.kernel_name.downcase}-#{Hardware::CPU.arch}"
    end

    bin.install libexec.glob("bin/#{platform}/*")
    bin.env_script_all_files libexec/"bin"/platform, CHPL_HOME: libexec
    man1.install_symlink libexec.glob("man/man1/*.1")
  end

  test do
    ENV["CHPL_HOME"] = libexec
    ENV["CHPL_INCLUDE_PATH"] = HOMEBREW_PREFIX/"include"
    ENV["CHPL_LIB_PATH"] = HOMEBREW_PREFIX/"lib"
    cd libexec do
      with_env(CHPL_LLVM: "system") do
        system "util/test/checkChplInstall"
      end
      with_env(CHPL_LLVM: "none") do
        system "util/test/checkChplInstall"
      end
    end
    system bin/"chpl", "--print-passes", "--print-commands", libexec/"examples/hello.chpl"
  end
end

__END__
--- a/third-party/chpl-venv/Makefile
+++ b/third-party/chpl-venv/Makefile
@@ -6,6 +6,13 @@ CHPL_MAKE_HOST_TARGET = --host
 include $(CHPL_MAKE_HOME)/make/Makefile.base
 include $(THIRD_PARTY_DIR)/chpl-venv/Makefile.include

+# CHPL_PIP_INSTALL_PARAMS can be set to adjust the pip arguments,
+# but if you want to build from source, set CHPL_PIP_FROM_SOURCE
+
+ifdef CHPL_PIP_FROM_SOURCE
+  CHPL_PIP_INSTALL_PARAMS=--no-binary :all:
+endif
+
 default: all

 all: test-venv chpldoc-venv
@@ -20,51 +27,50 @@ clobber: FORCE clean

 OLD_PYTHON_ERROR="python3 version 3.5 or later is required to install chpldoc and start_test dependencies. See https://www.python.org/"

-# Create the virtualenv to use during build.
-#  (to allow for a different path to the system python3 in the future)
-$(CHPL_VENV_VIRTUALENV_DIR_OK):
+$(CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK):
 	@# First check the python version is OK
-	@case `$(PYTHON) --version` in \
-	  *"Python 3.0"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.1"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.2"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.3"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3.4"*) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	  *"Python 3"*) \
-	    ;; \
-	  *) \
-	    echo $(OLD_PYTHON_ERROR) ; \
-            exit 1 ; \
-	    ;; \
-	esac
+	@if $(PYTHON) -c 'import sys; sys.exit(int(sys.version_info[:2] >= (3, 5)))'; then \
+	  echo $(OLD_PYTHON_ERROR); \
+	  exit 1; \
+	fi

 	@# Now create the venv to use to get the dependencies
 	$(PYTHON) -m venv $(CHPL_VENV_VIRTUALENV_DIR)
+	@# Now install wheel so we can pip install
+	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
+	export VIRTUAL_ENV=$(CHPL_VENV_VIRTUALENV_DIR) && \
+	$(PIP) install --upgrade \
+	  $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) wheel && \
+	touch $(CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK)
+
+ifdef CHPL_PIP_FROM_SOURCE
+$(CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK): $(CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK)
+	@# Now install source dependencies so we can build from source
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
 	export VIRTUAL_ENV=$(CHPL_VENV_VIRTUALENV_DIR) && \
-	$(PIP) install \
-	--upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) wheel && \
+	$(PIP) install --upgrade \
+	  $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) && \
+	$(PIP) install --upgrade \
+	   $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	   -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) && \
+	touch $(CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK)
+
+else
+$(CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK): $(CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK)
+	touch $(CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK)
+
+endif
+
+# Create the virtualenv to use during build.
+#  (to allow for a different path to the system python3 in the future)
+$(CHPL_VENV_VIRTUALENV_DIR_OK): $(CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK) $(CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK)
 	touch $(CHPL_VENV_VIRTUALENV_DIR_OK)

 # Phony convenience target for creating virtualenv.
 create-virtualenv: $(CHPL_VENV_VIRTUALENV_DIR_OK)

-$(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQUIREMENTS_FILE) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE) $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) chpldeps-main.py
+$(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQUIREMENTS_FILE) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3) $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) chpldeps-main.py
 	@# Install dependencies to $(CHPL_VENV_CHPLDEPS)
 	@# Rely on pip to create the directory
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
@@ -72,7 +78,9 @@ $(CHPL_VENV_CHPLDEPS_MAIN): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_TEST_REQU
 	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
 	  --target $(CHPL_VENV_CHPLDEPS) \
 	  -r $(CHPL_VENV_TEST_REQUIREMENTS_FILE) \
-	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2) \
+	  -r $(CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3) \
 	  -r $(CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE) && \
 	cp chpldeps-main.py $(CHPL_VENV_CHPLDEPS_MAIN)

@@ -89,8 +97,7 @@ install-requirements: install-chpldeps
 $(CHPL_VENV_CHPLSPELL_REQS): $(CHPL_VENV_VIRTUALENV_DIR_OK) $(CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE)
 	export PATH="$(CHPL_VENV_VIRTUALENV_BIN):$$PATH" && \
 	export VIRTUAL_ENV=$(CHPL_VENV_VIRTUALENV_DIR) && \
-	$(PIP) install \
-	  --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
+	$(PIP) install --upgrade $(CHPL_PIP_INSTALL_PARAMS) $(LOCAL_PIP_FLAGS) \
 	  -r $(CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE) && \
 	touch $(CHPL_VENV_CHPLSPELL_REQS)

--- a/third-party/chpl-venv/Makefile.include
+++ b/third-party/chpl-venv/Makefile.include
@@ -6,7 +6,9 @@
 CHPL_VENV_DIR=$(shell cd $(THIRD_PARTY_DIR)/chpl-venv && pwd)

 CHPL_VENV_TEST_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/test-requirements.txt
-CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/chpldoc-requirements.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE1=$(CHPL_VENV_DIR)/chpldoc-requirements1.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE2=$(CHPL_VENV_DIR)/chpldoc-requirements2.txt
+CHPL_VENV_CHPLDOC_REQUIREMENTS_FILE3=$(CHPL_VENV_DIR)/chpldoc-requirements3.txt
 CHPL_VENV_C2CHAPEL_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/c2chapel-requirements.txt

 CHPL_VENV_CHPLSPELL_REQUIREMENTS_FILE=$(CHPL_VENV_DIR)/chplspell-requirements.txt
@@ -23,6 +25,8 @@ PIP=$(PYTHON) -m pip
 CHPL_VENV_BUILD=$(CHPL_VENV_DIR)/build
 CHPL_VENV_VIRTUALENV_DIR=$(CHPL_VENV_BUILD)/build-venv
 CHPL_VENV_VIRTUALENV_DIR_OK=$(CHPL_VENV_BUILD)/build-venv/ok
+CHPL_VENV_VIRTUALENV_DIR_DEPS1_OK=$(CHPL_VENV_BUILD)/build-venv/ok1
+CHPL_VENV_VIRTUALENV_DIR_DEPS2_OK=$(CHPL_VENV_BUILD)/build-venv/ok2
 CHPL_VENV_VIRTUALENV_BIN=$(CHPL_VENV_VIRTUALENV_DIR)/bin
 CHPL_VENV_INSTALL=$(CHPL_VENV_DIR)/install
 CHPL_VENV_CHPLDEPS=$(CHPL_VENV_INSTALL)/chpldeps

--- a/third-party/chpl-venv/chpldoc-requirements.txt
+++ /dev/null
@@ -1,9 +0,0 @@
-Jinja2==3.0.1
-MarkupSafe==2.0.1
-Pygments==2.9.0
-Sphinx==4.0.2
-docutils==0.16.0
-sphinx-rtd-theme==0.5.2
-sphinxcontrib-chapeldomain==0.0.20
-babel==2.9.1
-breathe==4.30.0

--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements1.txt
@@ -0,0 +1,2 @@
+# Split into 3 files to work around problems with CHPL_PIP_FROM_SOURCE
+MarkupSafe==2.0.1

--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements2.txt
@@ -0,0 +1,6 @@
+# Split into 3 files to work around problems with CHPL_PIP_FROM_SOURCE
+Jinja2==3.0.1
+Pygments==2.9.0
+Sphinx==4.3.2
+docutils==0.16.0
+babel==2.9.1

--- /dev/null
+++ b/third-party/chpl-venv/chpldoc-requirements3.txt
@@ -0,0 +1,4 @@
+# Split into 3 files to work around problems with CHPL_PIP_FROM_SOURCE
+sphinx-rtd-theme==1.0.0
+sphinxcontrib-chapeldomain==0.0.21
+breathe==4.31.0
--- a/util/chplenv/chpl_llvm.py
+++ b/util/chplenv/chpl_llvm.py
@@ -110,10 +110,16 @@ def check_llvm_config(llvm_config):

 @memoize
 def find_system_llvm_config():
+    llvm_config = overrides.get('CHPL_LLVM_CONFIG', 'none')
+    if llvm_config != 'none':
+        return llvm_config
+
     paths = [ ]
     for vers in llvm_versions():
         paths.append("llvm-config-" + vers + ".0")
         paths.append("llvm-config-" + vers)
+        # this format used by freebsd
+        paths.append("llvm-config" + vers)
         # next ones are for Homebrew
         paths.append("/usr/local/opt/llvm@" + vers + ".0/bin/llvm-config")
         paths.append("/usr/local/opt/llvm@" + vers + "/bin/llvm-config")
@@ -299,7 +305,14 @@ def llvm_enabled():
 def get_gcc_prefix():
     gcc_prefix = overrides.get('CHPL_LLVM_GCC_PREFIX', '')

+
     if not gcc_prefix:
+        # darwin and FreeBSD default to clang
+        # so shouldn't need GCC prefix
+        host_platform = chpl_platform.get('host')
+        if host_platform == "darwin" or host_platform == "freebsd":
+            return ''
+
         # When 'gcc' is a command other than '/usr/bin/gcc',
         # compute the 'gcc' prefix that LLVM should use.
         gcc_path = find_executable('gcc')
@@ -402,12 +415,16 @@ def get_clang_additional_args():
         if arg == '-isysroot':
             has_sysroot = True

-    if has_sysroot:
-        # Work around a bug in some versions of Clang that forget to
+    # Check to see if Homebrew is installed. If it is,
+    # add the result of `brew prefix` to -I and -L args.
+    exists, retcode, my_out, my_err = try_run_command(['brew', '--prefix'])
+    if exists and retcode == 0:
+        # Make sure to include homebrew search path
+        homebrew_prefix = my_out.strip()
         # search /usr/local/include and /usr/local/lib
         # if there is a -isysroot argument.
-        comp_args.append('-I/usr/local/include')
-        link_args.append('-L/usr/local/lib')
+        comp_args.append('-I' + homebrew_prefix + '/include')
+        link_args.append('-L' + homebrew_prefix + '/lib')

     return (comp_args, link_args)

--- a/util/chplenv/chpl_compiler.py
+++ b/util/chplenv/chpl_compiler.py
@@ -1,10 +1,9 @@
 #!/usr/bin/env python3
 import optparse
 import os
+import shutil
 import sys

-from distutils.spawn import find_executable
-
 import chpl_platform, overrides
 from utils import error, memoize, warning

@@ -193,7 +192,7 @@ def get(flag='host'):
         elif platform_val.startswith('pwr'):
             compiler_val = 'ibm'
         elif platform_val == 'darwin' or platform_val == 'freebsd':
-            if find_executable('clang'):
+            if shutil.which('clang'):
                 compiler_val = 'clang'
             else:
                 compiler_val = 'gnu'

--- a/util/chplenv/chpl_launcher.py
+++ b/util/chplenv/chpl_launcher.py
@@ -1,5 +1,5 @@
 #!/usr/bin/env python3
-from distutils.spawn import find_executable
+import shutil
 import sys

 import chpl_comm, chpl_comm_substrate, chpl_platform, overrides
@@ -7,7 +7,7 @@ from utils import error, memoize, warning

 def slurm_prefix(base_launcher, platform_val):
     """ If salloc is available and we're on a cray-cs/hpe-apollo, prefix with slurm-"""
-    if platform_val in ('cray-cs', 'hpe-apollo') and find_executable('salloc'):
+    if platform_val in ('cray-cs', 'hpe-apollo') and shutil.which('salloc'):
         return 'slurm-{}'.format(base_launcher)
     return base_launcher

@@ -29,8 +29,8 @@ def get():
         platform_val = chpl_platform.get('target')

         if platform_val.startswith('cray-x') or platform_val.startswith('hpe-cray-'):
-            has_aprun = find_executable('aprun')
-            has_slurm = find_executable('srun')
+            has_aprun = shutil.which('aprun')
+            has_slurm = shutil.which('srun')
             if has_aprun and has_slurm:
                 launcher_val = 'none'
             elif has_aprun:
@@ -60,7 +60,7 @@ def get():
             elif substrate_val == 'ofi':
                 launcher_val = slurm_prefix('gasnetrun_ofi', platform_val)
         else:
-            if platform_val in ('cray-cs', 'hpe-apollo') and find_executable('srun'):
+            if platform_val in ('cray-cs', 'hpe-apollo') and shutil.which('srun'):
                 launcher_val = 'slurm-srun'
             else:
                 launcher_val = 'none'

--- a/util/chplenv/chpl_llvm.py
+++ b/util/chplenv/chpl_llvm.py
@@ -1,8 +1,8 @@
 #!/usr/bin/env python3
 import optparse
 import os
+import shutil
 import sys
-from distutils.spawn import find_executable
 import re

 import chpl_bin_subdir, chpl_arch, chpl_compiler, chpl_platform, overrides
@@ -302,7 +302,7 @@ def get_gcc_prefix():
     if not gcc_prefix:
         # When 'gcc' is a command other than '/usr/bin/gcc',
         # compute the 'gcc' prefix that LLVM should use.
-        gcc_path = find_executable('gcc')
+        gcc_path = shutil.which('gcc')
         if gcc_path == '/usr/bin/gcc' :
             # In this common case, nothing else needs to be done,
             # because we can assume that clang can find this gcc.

--- a/util/chplenv/chpl_make.py
+++ b/util/chplenv/chpl_make.py
@@ -1,5 +1,5 @@
 #!/usr/bin/env python3
-from distutils.spawn import find_executable
+import shutil
 import sys

 import chpl_platform, overrides
@@ -14,7 +14,7 @@ def get():
         if platform_val.startswith('cygwin') or platform_val == 'darwin':
             make_val = 'make'
         elif platform_val.startswith('linux'):
-            if find_executable('gmake'):
+            if shutil.which('gmake'):
                 make_val = 'gmake'
             else:
                 make_val = 'make'
